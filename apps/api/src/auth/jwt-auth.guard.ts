import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { verify, JwtPayload } from 'jsonwebtoken';
import {
  AuthClaims,
  AuthenticatedRequest,
} from './authenticated-request.interface';

@Injectable()
export class JwtAuthGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const secret = process.env.JWT_ACCESS_SECRET;

    if (!secret || secret.length < 32) {
      throw new UnauthorizedException(
        'Authentication is not configured',
      );
    }

    const request = context
      .switchToHttp()
      .getRequest<AuthenticatedRequest>();

    const authorization = request.headers.authorization;

    if (!authorization?.startsWith('Bearer ')) {
      throw new UnauthorizedException('Bearer token required');
    }

    const token = authorization.slice(7).trim();

    if (!token) {
      throw new UnauthorizedException('Invalid access token');
    }

    try {
      const decoded = verify(token, secret, {
        algorithms: ['HS256'],
      });

      if (
        typeof decoded === 'string' ||
        typeof (decoded as JwtPayload).sub !== 'string' ||
        typeof (decoded as JwtPayload).exp !== 'number'
      ) {
        throw new Error('Invalid JWT claims');
      }

      const claims = decoded as AuthClaims;

      if (
        !claims.sub.trim() ||
        !Number.isFinite(claims.exp) ||
        claims.exp <= Math.floor(Date.now() / 1000)
      ) {
        throw new Error('Invalid JWT identity or expiry');
      }

      request.user = claims;
      return true;
    } catch {
      throw new UnauthorizedException('Invalid or expired access token');
    }
  }
}
