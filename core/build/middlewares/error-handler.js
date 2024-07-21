"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.errorHandler = void 0;
const BaseError_1 = require("../errors/BaseError");
const errorHandler = (error, req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    if (error instanceof BaseError_1.BaseError) {
        res.status(error.statusCode).send({ errors: error.getSerializedErrors() });
    }
    else {
        res
            .status(500)
            .send({ errors: [{ message: `Server error ${error === null || error === void 0 ? void 0 : error.message}` }] });
    }
    next();
});
exports.errorHandler = errorHandler;
