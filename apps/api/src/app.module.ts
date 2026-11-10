import { Module } from '@nestjs/common';
import { HealthModule } from './health/health.module';
import { LiveModule } from './live/live.module';
import { AuthModule } from './auth/auth.module';

@Module({
  imports: [HealthModule, LiveModule, AuthModule],
})
export class AppModule {}
