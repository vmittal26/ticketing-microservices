import {
  BaseListener,
  Subjects,
  TicketCreatedEvent,
} from '@coretickets/modules';
import { Message } from 'node-nats-streaming';
import { Ticket } from '../model/Ticket';

export class TicketCreatedListener extends BaseListener<TicketCreatedEvent> {
  subject: Subjects.TicketCreatedEvent = Subjects.TicketCreatedEvent;
  queueGroupName = 'orders-service';

  
  async onMessage(data: TicketCreatedEvent['data'], message: Message) {

    console.log('Message -> TicketCreatedEvent');
    const { id,   title, price , version } = data;

    const ticket = Ticket.build({
      id,
      title,
      price,
      version
    });

    await ticket.save();
    

    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    //@ts-ignore
    const count =  message.getRedeliveryCount();

    console.log(count);
   
    message.ack();
  }
}
