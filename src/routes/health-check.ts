import type { FastifyInstance } from "fastify";
import { log } from "../infra/logger";

export async function healthCheckRoute(app: FastifyInstance) {
  app.get('/health', async (request, reply) => {
    log.info('Health check request received');
    await reply.status(200).send({ message: 'OK!' })
  })
}