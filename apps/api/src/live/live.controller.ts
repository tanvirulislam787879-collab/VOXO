import {
  Body,
  Controller,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import { AuthenticatedRequest } from '../auth/authenticated-request.interface';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CreateLiveTokenDto } from './dto/create-live-token.dto';
import { LiveTokenService } from './live-token.service';

@Controller('live')
@UseGuards(JwtAuthGuard)
export class LiveController {
  constructor(
    private readonly liveTokenService: LiveTokenService,
  ) {}

  @Post('token')
  createToken(
    @Req() request: AuthenticatedRequest,
    @Body() body: CreateLiveTokenDto,
  ) {
    return this.liveTokenService.createToken(
      request.user,
      body.roomName,
    );
  }
}
