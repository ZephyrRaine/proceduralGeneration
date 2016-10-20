void ExpandRooms()
{
 //for(Room r : roomsList)
 for(int j = roomsList.size()-1; j > 0; j--)
 {
  if(random(1) < mapParams.ratioBigRooms && j < roomsList.size())
 {
   Room r = roomsList.get(j);
   if(r.tSizeX == 1 && r.tSizeY == 1  && r != startingRoom) ExpandRoom(r);
 }
 }
}

void ExpandRoom(Room r)
{
  //  Room r = roomsList.get(j);
 //   Room r = gridArray[x][y];
    Room rTested = null;
    Room rTemp = null;
    IntList order = new IntList();
    for(int i = 0; i < 4; i++)
    { 
      order.append(i);
    }
    order.shuffle(); 
    
    Boolean canExpand = false;
    int index = 0;
    do
    {
      canExpand = canExpand(r, order.get(index));
      if(!canExpand) index++;
    } while(!canExpand && index < 3);
    
    if(canExpand)
    {
      switch(order.get(index)) //<>//
      {
       case NE:
         rTested = gridArray[r.tX-1][r.tY];
         if(rTested != null && rTested != r && rTested != startingRoom) roomsList.remove(rTested);
         else gridArray[r.tX-1][r.tY] = r;
         rTested = gridArray[r.tX][r.tY-1];
         if(rTested != null && rTested != r && rTested != startingRoom) roomsList.remove(rTested);
         else gridArray[r.tX][r.tY-1] = r;
         
         rTested = gridArray[r.tX-1][r.tY-1];
         if(rTested != null && rTested != r && rTested != startingRoom) roomsList.remove(rTested);
         else gridArray[r.tX-1][r.tY-1] = r;
         
         
         r.tSizeX = -2;
        r.tSizeY = -2;
         break;
       case NW:
         rTested = gridArray[r.tX+1][r.tY];
         if(rTested != null && rTested != r && rTested != startingRoom) roomsList.remove(rTested);
         gridArray[r.tX+1][r.tY] = r;
         rTested = gridArray[r.tX][r.tY-1];
         if(rTested != null && rTested != r && rTested != startingRoom) roomsList.remove(rTested);
         gridArray[r.tX][r.tY-1] = r;
         
         rTested = gridArray[r.tX+1][r.tY-1];
          if(rTested != null && rTested != r && rTested != startingRoom) roomsList.remove(rTested);
         else gridArray[r.tX+1][r.tY-1] = r;
         
         r.tSizeX = 2;
         r.tSizeY = -2;
         break;
       case SE:
         rTested = gridArray[r.tX-1][r.tY];
         if(rTested != null && rTested != r && rTested != startingRoom) roomsList.remove(rTested);
         gridArray[r.tX-1][r.tY] = r;
         rTested = gridArray[r.tX][r.tY+1];
         if(rTested != null && rTested != r && rTested != startingRoom) roomsList.remove(rTested);
         gridArray[r.tX][r.tY+1] = r;
         
         rTested = gridArray[r.tX-1][r.tY+1];
          if(rTested != null && rTested != r && rTested != startingRoom) roomsList.remove(rTested);
         else gridArray[r.tX-1][r.tY+1] = r;
         
         r.tSizeX = -2;
         r.tSizeY = 2;
         break;
       case SW:
         rTested = gridArray[r.tX+1][r.tY];
         if(rTested != null && rTested != r && rTested != startingRoom) roomsList.remove(rTested);
         gridArray[r.tX+1][r.tY] = r;
         rTested = gridArray[r.tX][r.tY+1];
         if(rTested != null && rTested != r && rTested != startingRoom) roomsList.remove(rTested);
         gridArray[r.tX][r.tY+1] = r;
         
         rTested = gridArray[r.tX+1][r.tY+1];
          if(rTested != null && rTested != r && rTested != startingRoom) roomsList.remove(rTested);
         else gridArray[r.tX+1][r.tY+1] = r;
         
         r.tSizeX = 2;
         r.tSizeY = 2;
         break;
         }
         
         r.tX = r.aX();
         r.tY = r.aY();
         r.tSizeX = 2;
         r.tSizeY = 2;
      }
    }


boolean canExpand(Room r, int dir)
{
  int testedX, testedY;
  Room testedRooms[] = new Room[3];
  boolean returnValue = true;
  switch(dir)
  {
    case NE:
      if((gridArray[r.tX-1][r.tY] != null && (gridArray[r.tX-1][r.tY].tSizeX != 1 || gridArray[r.tX-1][r.tY].tSizeY != 1)) ||
      (gridArray[r.tX][r.tY-1] != null && (gridArray[r.tX][r.tY-1].tSizeX != 1 || gridArray[r.tX][r.tY-1].tSizeY != 1))) returnValue = false;
      testedX = r.tX-1;
      testedY = r.tY-1;
      testedRooms[0] = gridArray[testedX][testedY];
      testedRooms[1] = gridArray[testedX-1][testedY];
      testedRooms[2] = gridArray[testedX][testedY-1];
      break;
    case NW:
      if((gridArray[r.tX+1][r.tY] != null && (gridArray[r.tX+1][r.tY].tSizeX != 1 || gridArray[r.tX+1][r.tY].tSizeY != 1)) ||
      (gridArray[r.tX][r.tY-1] != null && (gridArray[r.tX][r.tY-1].tSizeX != 1 || gridArray[r.tX][r.tY-1].tSizeY != 1))) returnValue = false;
      testedX = r.tX+1;
      testedY = r.tY-1;
      testedRooms[0] = gridArray[testedX][testedY];
      testedRooms[1] = gridArray[testedX+1][testedY];
      testedRooms[2] = gridArray[testedX][testedY-1];
      break;
    case SE:
      if((gridArray[r.tX+1][r.tY] != null && (gridArray[r.tX+1][r.tY].tSizeX != 1 || gridArray[r.tX+1][r.tY].tSizeY != 1)) ||
      (gridArray[r.tX][r.tY+1] != null && (gridArray[r.tX][r.tY+1].tSizeX != 1 || gridArray[r.tX][r.tY+1].tSizeY != 1))) returnValue = false;
      testedX = r.tX+1;
      testedY = r.tY+1;
      testedRooms[0] = gridArray[testedX][testedY];
      testedRooms[1] = gridArray[testedX-1][testedY];
      testedRooms[2] = gridArray[testedX][testedY+1];
      break;
    case SW:
      if((gridArray[r.tX-1][r.tY] != null && (gridArray[r.tX-1][r.tY].tSizeX != 1 || gridArray[r.tX-1][r.tY].tSizeY != 1)) ||
      (gridArray[r.tX][r.tY+1] != null && (gridArray[r.tX][r.tY+1].tSizeX != 1 || gridArray[r.tX][r.tY+1].tSizeY != 1))) returnValue = false;
      testedX = r.tX-1;
      testedY = r.tY+1;
      testedRooms[0] = gridArray[testedX][testedY];
      testedRooms[1] = gridArray[testedX+1][testedY];
      testedRooms[2] = gridArray[testedX][testedY+1];
      break;
  }
  
  for(int i = 0; i < 3; i++)
  {
    if(testedRooms[i] != null) returnValue = false;
  }
  
  return returnValue;
}