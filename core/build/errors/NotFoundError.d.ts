import { BaseError } from './BaseError';
export declare class NotFoundError extends BaseError {
    message: string;
    statusCode: number;
    constructor(message: string);
}
