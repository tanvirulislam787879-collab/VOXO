import { Module } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { LiveController } from './live.controller';
import { LiveTokenService } from './live-token.service';

@Module({
  controllers: [LiveController],
  providers: [LiveTokenService, JwtAuthGuard],
  exports: [LiveTokenService],
})
export class LiveModule {}
