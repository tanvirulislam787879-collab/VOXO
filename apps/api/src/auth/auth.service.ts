import {
  ConflictException,
  Injectable,
  OnModuleDestroy,
  ServiceUnavailableException,
  UnauthorizedException,
} from '@nestjs/common';
import { Pool } from 'pg';
import * as bcrypt from 'bcryptjs';
import { sign } from 'jsonwebtoken';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';

interface UserRow {
  id: string;
  email: string;
  password_hash: string;
  display_name: string;
  created_at: Date;
}

@Injectable()
export class AuthService implements OnModuleDestroy {
  private pool?: Pool;

  private getPool(): Pool {
    if (this.pool) return this.pool;

    const connectionString = process.env.DATABASE_URL;

    if (!connectionString) {
      throw new ServiceUnavailableException(
        'Database is not configured',
      );
    }

    this.pool = new Pool({
      connectionString,
      max: 10,
      connectionTimeoutMillis: 5000,
      idleTimeoutMillis: 30000,
      ssl: process.env.DATABASE_SSL === 'true'
        ? { rejectUnauthorized: true }
        : undefined,
    });

    return this.pool;
  }

  private createAccessToken(user: UserRow) {
    const secret = process.env.JWT_ACCESS_SECRET;

    if (!secret || secret.length < 32) {
      throw new ServiceUnavailableException(
        'JWT authentication is not configured',
      );
    }

    const accessToken = sign(
      {
        sub: user.id,
        email: user.email,
        displayName: user.display_name,
        hostRoomIds: [],
        viewerRoomIds: [],
      },
      secret,
      {
        algorithm: 'HS256',
        expiresIn: '1h',
      },
    );

    return {
      accessToken,
      tokenType: 'Bearer',
      expiresIn: 3600,
    };
  }

  async register(dto: RegisterDto) {
    const pool = this.getPool();

    const email = dto.email.trim().toLowerCase();
    const displayName = dto.displayName?.trim() || email.split('@')[0];
    const passwordHash = await bcrypt.hash(dto.password, 12);

    try {
      const result = await pool.query<UserRow>(
        `INSERT INTO users (email, password_hash, display_name)
         VALUES ($1, $2, $3)
         RETURNING id, email, password_hash, display_name, created_at`,
        [email, passwordHash, displayName],
      );

      const user = result.rows[0];

      return {
        ...this.createAccessToken(user),
        user: {
          id: user.id,
          email: user.email,
          displayName: user.display_name,
          createdAt: user.created_at,
        },
      };
    } catch (error) {
      if ((error as { code?: string }).code === '23505') {
        throw new ConflictException('Email is already registered');
      }

      throw error;
    }
  }

  async login(dto: LoginDto) {
    const pool = this.getPool();

    const email = dto.email.trim().toLowerCase();

    const result = await pool.query<UserRow>(
      `SELECT id, email, password_hash, display_name, created_at
       FROM users
       WHERE email = $1
       LIMIT 1`,
      [email],
    );

    const user = result.rows[0];

    if (!user || !(await bcrypt.compare(dto.password, user.password_hash))) {
      throw new UnauthorizedException('Invalid email or password');
    }

    return {
      ...this.createAccessToken(user),
      user: {
        id: user.id,
        email: user.email,
        displayName: user.display_name,
        createdAt: user.created_at,
      },
    };
  }

  async getProfile(userId: string) {
    const result = await this.getPool().query<UserRow>(
      `SELECT id, email, password_hash, display_name, created_at
       FROM users
       WHERE id = $1
       LIMIT 1`,
      [userId],
    );

    const user = result.rows[0];

    if (!user) {
      throw new UnauthorizedException('User account not found');
    }

    return {
      id: user.id,
      email: user.email,
      displayName: user.display_name,
      createdAt: user.created_at,
    };
  }

  async onModuleDestroy() {
    if (this.pool) {
      await this.pool.end();
    }
  }
}
