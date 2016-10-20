class Room
{
  int tX;
  int tY;
  
  int tSizeX;
  int tSizeY;
  
  Room[][] doors;
  
  int distanceFromStart;
  int distanceMax;
  
  boolean terminate;
  
  Room(int _x, int _y)
  {
    tX = _x;
    tY = _y;
    
    distanceFromStart = 0;
    
    tSizeX = tSizeY = 1;
    
    doors = new Room[4][2];
    for(int i = 0; i < 4; i++) 
    {
      doors[i][0] = null;
      doors[i][1] = null;
    }
  }
  
  int aX()
  {
    return tSizeX==-2?tX-1:tX; 
  }
  
  int aY()
  {
    return tSizeY==-2?tY-1:tY;
  }
  
  void addDoor(int dir, Room target)
  {
    doors[dir][0] = target; 
    mapInfos.nbCountDoors++;
  }
  
  void addDoor(int dir, int dir2, Room target)
  {
    doors[dir][dir2] = target;
    mapInfos.nbCountDoors++;
  }
  
  void drawRoom()
  {
    int x = tX*tWidth;
    int y = tY*tHeight;
    if(showOrigin)
    {
      fill(125,96,96,32);
      ellipse(x+tWidth/2.0, y+tHeight/2.0, tWidth, tHeight);
    }
    if(tX == mouseX/tWidth && tY == mouseY/tHeight) 
    {
      fill(196,196,218,224);
    }
    else fill(156,156,196,196);
      rect(tSizeX<0?x+(tWidth*(tSizeX+1)):x, tSizeY<0?y+(tHeight*(tSizeY+1)):y, abs(tSizeX)*tWidth, abs(tSizeY)*tHeight);
    
    if(this == startingRoom)
    {
      fill(255,16,16,64);
      ellipse(x+tWidth/2.0, y+tHeight/2.0, tWidth/2.0, tHeight/2.0);
    }
    
    if(showDistance)
    {
      fill(0);
      text(distanceFromStart, x+3, y+13);
    }
    
    for(int k = 0; k < 4; k++)
    {
     if(doors[k][0] != null)
       {
         switch(k)
         {
         case NORTH:
           line(x+tWidth/2, y, x+tWidth/2, y+tHeight/4);
           break;
         case SOUTH:
           line(x+tWidth/2, y+(tHeight*(tSizeY)), x+tWidth/2, y+(tHeight*(tSizeY))-tHeight/4);
           break;
         case EAST:
           line(x+(tWidth*(tSizeX)), y+tHeight/2, x+(tWidth*(tSizeX))-tWidth/4, y+tHeight/2);
           break;
         case WEST:
           line(x, y+tHeight/2, x+tWidth/4, y+tHeight/2);
           break;
         }
       }
       if(doors[k][1] != null)
       {
         switch(k)
         {
         case NORTH:
           line(x+(tWidth*(tSizeX))-tWidth/2, y, x+(tWidth*(tSizeX))-tWidth/2, y+tHeight/4);
           break;
         case SOUTH:
           line(x+(tWidth*(tSizeX))-tWidth/2, y+(tHeight*(tSizeY)), x+(tWidth*(tSizeX))-tWidth/2, y+(tHeight*(tSizeY))-tHeight/4);
           break;
         case EAST:
           line(x+(tWidth*(tSizeX)), y+(tHeight*(tSizeY))-tHeight/2, x+(tWidth*(tSizeX))-tWidth/4, y+(tHeight*(tSizeY))-tHeight/2);
           break;
         case WEST:
           line(x, y+(tHeight*(tSizeY))-tHeight/2, x+tWidth/4, y+(tHeight*(tSizeY))-tHeight/2);
           break;
         }
       }
     }
  
  }
  
}


void PlaceDoors()
{
 for(Room r : roomsList)
 {
     Room t = null;
     if(r != null)
     {
       if(r.tSizeX == 1 && r.tSizeY == 1)
       {
         t = gridArray[r.tX-1][r.tY]; if(t != null && t != r) r.addDoor(WEST, t);
         t = gridArray[r.tX+1][r.tY]; if(t != null && t != r) r.addDoor(EAST, t);
         t = gridArray[r.tX][r.tY-1]; if(t != null && t != r) r.addDoor(NORTH, t);
         t = gridArray[r.tX][r.tY+1]; if(t != null && t != r) r.addDoor(SOUTH, t);
       }
       else 
       {
         t = gridArray[r.tX-1][r.tY]; if(t != null && t != r) r.addDoor(WEST, 0, t);
         t = gridArray[r.tX-1][r.tY+1]; if(t != null && t != r) r.addDoor(WEST, 1, t);
         
         t = gridArray[r.tX+2][r.tY]; if(t != null && t != r) r.addDoor(EAST, 0, t);
         t = gridArray[r.tX+2][r.tY+1]; if(t != null && t != r) r.addDoor(EAST, 1, t);
         
         t = gridArray[r.tX][r.tY-1]; if(t != null && t != r) r.addDoor(NORTH, 0, t);
         t = gridArray[r.tX+1][r.tY-1]; if(t != null && t != r) r.addDoor(NORTH, 1, t);
         
         t = gridArray[r.tX][r.tY+2]; if(t != null && t != r) r.addDoor(SOUTH, 0, t);
         t = gridArray[r.tX+1][r.tY+2]; if(t != null && t != r) r.addDoor(SOUTH, 1, t);
       }
    }
  }
}


void DrawRooms()
{
  pushMatrix();
  stroke(196);
  for(int i = roomsList.size()-1; i >= 0; i--)
  {
    roomsList.get(i).drawRoom();
  }

  popMatrix();
}

Boolean isValidFrom(int x, int y, int dir)
{
  switch(dir)
  {
   case NORTH:
    if(y+1 < tRows && gridArray[x][y+1] == null
    && x-1 > 0 && gridArray[x-1][y] == null
    && x+1 < tColumns && gridArray[x+1][y] == null) return true;
    else return false;
    case SOUTH:
    if(y-1 > 0 && gridArray[x][y-1] == null
    && x-1 > 0 && gridArray[x-1][y] == null
    && x+1 < tColumns && gridArray[x+1][y] == null) return true;
    else return false;
    case EAST:
    if(x-1 > 0 && gridArray[x-1][y] == null
    && y-1 > 0 && gridArray[x][y-1] == null
    && y+1 < tRows && gridArray[x][y+1] == null) return true;
    else return false;
    case WEST:
    if(x+1 < tColumns && gridArray[x+1][y] == null
    && y-1 > 0 && gridArray[x][y-1] == null
    && y+1 < tRows && gridArray[x][y+1] == null) return true;
    else return false;
  }
  
  return false;
}

void InitRooms()
{
                                    
  surface.setResizable(true);
  surface.setSize(mapWidth,mapHeight);
  
  tWidth = tempTWidth;
  tHeight = tempTHeight;
  
  mapWidth = tempMapWidth;
  mapHeight = tempMapHeight;
  
  tColumns = mapWidth/tWidth;
  tRows = mapHeight/tHeight;
  
  gridArray = new Room[tColumns][tRows];
  roomsList = new ArrayList<Room>();
  
  stockInfos.add(mapInfos);
  PrintReport();
  mapInfos = new MapInfos();

  
  for(int i = 0; i < tRows; i++)
  {
    for(int j = 0; j < tColumns; j++)
    {
      gridArray[j][i] = null;
    }
  }
  startingRoom = gridArray[tColumns/2][tRows/2] = new Room(tColumns/2, tRows/2);
  roomsList.add(startingRoom);
  
  createMaze(startingRoom, int(random(mapParams.nbIterationsMin, mapParams.nbIterationsMax+1)));
  ExpandRooms();
  PlaceDoors();
  wantToGenerate = false;
  startingRoom = gridArray[tColumns/2][tRows/2];
  distanceFromStart();
}