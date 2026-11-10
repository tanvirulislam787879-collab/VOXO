import { Request } from 'express';

export interface AuthClaims {
  sub: string;
  exp: number;
  displayName?: string;
  hostRoomIds?: string[];
  viewerRoomIds?: string[];
}

export interface AuthenticatedRequest extends Request {
  user: AuthClaims;
}
