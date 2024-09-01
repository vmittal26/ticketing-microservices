import mongoose from 'mongoose';
import { app } from './app';
// import { natsWrapper } from './nats-wrapper/NatsWrapper';
// import { OrderCreatedListener } from './listeners/OrderCreatedListener';

const start = async () => {
  try {

    const mongo_db_connection_str =   process.env['mongo-db-conn-str'];
    
    if (mongo_db_connection_str == null) {
      throw new Error('Mongo db instance env variable is missing');
    }


    // new OrderCreatedListener(natsWrapper.client).listen();

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



