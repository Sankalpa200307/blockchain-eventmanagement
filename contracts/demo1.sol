// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

//This defines a struct named Event with several properties representing the details of an event
contract EventContract{
    struct Event{
       address organizer;
       string name;
       uint date;
       uint price;
       uint ticketCount;
       uint ticketRemain;
    }

    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextId;

      //for event function
    function createEvent(string memory name,uint date,uint price,uint ticketCount) external{
      require(date>block.timestamp,"you can organize event for future date");
      require(ticketCount>0,"you can organize event only if you create more than 0 tickets");

      events[nextId]=Event(msg.sender,name,date,price,ticketCount,ticketCount);
      nextId++;
    }
      //for buy function
    function buyTicket(uint id,uint quantity) external payable{
        require(events[id].date!=0,"Event doesnot exist");//if date is 0
        require(events[id].date>block.timestamp,"Event has already occured");//Event is completed
        Event storage _event=events[id];
        require(msg.value==(_event.price*quantity),"Ether is not enough");
        require(_event.ticketRemain>=quantity,"Not enough tickets");
        _event.ticketRemain-=quantity;
        tickets[msg.sender][id]+=quantity;
    }

    //to transfer tickets to a friend
    function transferTicket(uint id,uint quantity,address to) external {
        require(events[id].date!=0,"Event doesnot exist");//if date is 0
        require(events[id].date>block.timestamp,"Event has already occured");//Event is completed
        require(tickets[msg.sender][id]>=quantity,"You do not have enough tickets");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
    }
}

