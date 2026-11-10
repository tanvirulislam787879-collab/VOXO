import {
  ForbiddenException,
  Injectable,
  InternalServerErrorException,
} from '@nestjs/common';
import { AccessToken } from 'livekit-server-sdk';
import { AuthClaims } from '../auth/authenticated-request.interface';

@Injectable()
export class LiveTokenService {
  async createToken(
    user: AuthClaims,
    roomName: string,
  ) {
    const serverUrl = process.env.LIVEKIT_URL;
    const apiKey = process.env.LIVEKIT_API_KEY;
    const apiSecret = process.env.LIVEKIT_API_SECRET;

    if (!serverUrl || !apiKey || !apiSecret) {
      throw new InternalServerErrorException(
        'LiveKit server configuration is missing',
      );
    }

    if (!serverUrl.startsWith('wss://')) {
      throw new InternalServerErrorException(
        'LIVEKIT_URL must use secure wss://',
      );
    }

    const hostRooms = Array.isArray(user.hostRoomIds)
      ? user.hostRoomIds
      : [];

    const viewerRooms = Array.isArray(user.viewerRoomIds)
      ? user.viewerRoomIds
      : [];

    const isHost = hostRooms.includes(roomName);
    const isViewer = viewerRooms.includes(roomName);

    if (!isHost && !isViewer) {
      throw new ForbiddenException(
        'You do not have permission to join this room',
      );
    }

    const role = isHost ? 'host' : 'viewer';

    const token = new AccessToken(apiKey, apiSecret, {
      identity: user.sub,
      name:
        typeof user.displayName === 'string'
          ? user.displayName.slice(0, 100)
          : user.sub,
      ttl: '10m',
    });

    token.addGrant({
      roomJoin: true,
      room: roomName,
      canPublish: role === 'host',
      canSubscribe: true,
      canPublishData: role === 'host',
    });

    return {
      serverUrl,
      participantToken: await token.toJwt(),
      roomName,
      identity: user.sub,
      role,
      expiresIn: 600,
    };
  }
}
