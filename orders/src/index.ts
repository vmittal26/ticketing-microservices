import mongoose from 'mongoose';
import { app } from './app';
// import { TicketCreatedListener } from './listeners/TicketCreatedListener';
// import { natsWrapper } from './nats-wrapper/NatsWrapper';
// import { TicketUpdatedListener } from './listeners/TicketUpdatedListeners';

const start = async () => {
  try {
    const mongo_db_connection_str =   process.env['mongo-db-conn-str'];
    if (mongo_db_connection_str == null) {
      throw new Error('Mongo db instance env variable is missing');
    }
  
    // await natsWrapper.natsConnect();

    // new TicketCreatedListener(natsWrapper.client).listen();
    // new TicketUpdatedListener(natsWrapper.client).listen();

    await mongoose.connect(mongo_db_connection_str);
    console.log('connected successfully!');

    app.listen(process.env.PORT, () => {
      console.log(`Listening on port ${process.env.PORT}`);
    });
  } catch (error) {
    console.error((error as Error)?.message ?? 'Error while connecting db');
  }
};

start();
