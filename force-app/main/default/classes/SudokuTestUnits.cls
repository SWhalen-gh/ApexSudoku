@isTest
public class SudokuTestUnits {
    
    @isTest
    static void xWing () {
        system.debug(loggingLevel.warn, 'test XWING '); 
        
    	string testData		=	'028709650'+
            					'754003980'+
            					'069000007'+
            					'031097060'+
            					'076300090'+
            					'095004370'+
            					'917456000'+
            					'542938716'+
            					'683172549';    
        
        GameData gd = new GameData();
        gd.populateGame(testData, false);
        
        gd.printGame(false);    

        house row2 = gd.rowHouses.get(2); 
        map<integer, set<gameCell>> r2c = row2.getCellsByCandidateBySize(2) ;
        system.debug(loggingLevel.warn, 'test XWING r2c = ' + r2c.keySet()); 
        
        assert.isTrue(r2c.containsKey(1));  
         
        house row6 = gd.rowHouses.get(6); 
        map<integer, set<gameCell>> r6c = row6.getCellsByCandidateBySize(2) ; 
        system.debug(loggingLevel.warn, 'test XWING r6c = ' + r6c.keySet()); 
        
        assert.isTrue(r6c.containsKey(1));  
         
        set<gameCell> r6cells= r6c.get(1);
        boolean isMatch = false;
        for (gameCell gc : r2c.get(1)) {
            for (gameCell gc2 :r6c.get(1) ){
               	if (!isMatch) isMatch = (gc.c == gc2.c);
                if (isMatch) continue;
            }   
            if (!isMatch) break;
        }
        
        assert.isTrue(isMatch);  
         
        map<integer, map<integer, set<gameCell>>> houseCellsByFrequency 
            = new map<integer, map<integer, set<gameCell>>>();
        map<integer, set<integer>> candidateToHouses  = new map<integer, set<integer>> ();
		map<integer, house> colHouses = gd.colHouses; 
        for (house ch :colHouses.values()){
			map<integer, set<gameCell>> vvv = ch.getCellsByCandidateBySize(2) ;     
            houseCellsByFrequency.put(ch.position, vvv);
          
            for (integer ccc : vvv.keyset()){
                set<integer> houses = candidateToHouses.get(ccc) ?? new set<integer>();
                houses.add(ch.position);
                candidateToHouses.put(ccc, houses);                  
            }
              
        }
        
        
        for (integer ccc :candidateToHouses.keySet() ) {
            set<integer> hs = candidateToHouses.get(ccc); 
        	system.debug(loggingLevel.warn, 'ccc = ' + ccc + ' hs = ' + hs ); 
            
            //for houses
            //get cells (4) 
            //opppsite Axis: when looping on col, rows are tested
            //for 4 cells, 2 coordinates must be equal to the house number
            // and 2 must be different from each other
            //(2,5),(2,9)
            //(6,5),(6,9)
                     
        }
        
        
        //for each candidate
        //for each house
        //make a set of the opposite coord values
        //c=1,h=1, oc=[1,5,9]
        //c=1,h=2, oc=[5,9]
        //c=1,h=5, oc=[6,7] 
        //c=1,h=6, oc=[5,9]  
        //if there are N sets with N candidates (2 sets with 2 candidates)
        //then start removing C from those opposite houses
		 /// 
    }
    

    @isTest
    static void testValidation() {
         
        system.debug(loggingLevel.warn, 'test validation ');
        
        string testData = '005160000600073000300005706000030691139756482862490000401000005000500008000007200';

        GameData gd = new GameData();
        gd.populateGame(testData, false);
        
        gd.printGame(false);    
        
        gameCell c = gd.getCell(1, 6);
        
        boolean isError = false;
        try{ 
        	c.cellValue = 5;
        }
        catch (exception e){
            isError = true;
        }
        
        assert.isTrue(isError);
        
    }
   
    @isTest
    static void HiddenSingleHouseLogic() {
        GameData game = new GameData();
     	
        game.getCell(1,2).cellValue = 1;
        game.getCell(1,6).cellValue = 3;
        game.getCell(2,4).cellValue = 5;
        game.getCell(2,7).cellValue = 9;
        game.getCell(2,9).cellValue = 3;
        game.getCell(3,5).cellValue = 2;
        game.getCell(3,6).cellValue = 9;
        game.getCell(4,2).cellValue = 8;
        game.getCell(5,1).cellValue = 2;
        game.getCell(5,2).cellValue = 7;
        game.getCell(5,3).cellValue = 9;
        game.getCell(5,4).cellValue = 1;
        game.getCell(5,5).cellValue = 5;
        game.getCell(5,6).cellValue = 6;
        game.getCell(5,7).cellValue = 8;
        game.getCell(5,8).cellValue = 3;
        game.getCell(5,9).cellValue = 4;
        game.getCell(6,1).cellValue = 4;
        game.getCell(6,3).cellValue = 6;
        game.getCell(8,1).cellValue = 3;
        game.getCell(8,3).cellValue = 2;
        game.getCell(8,6).cellValue = 1;
        
        gameCell cell = game.getCell(2,5);//
        house bbb = game.getHouseBox(cell);

        set<integer>  uniqueCandidatesBox = bbb.getUniqueCandidatesInCell(cell);
        system.Assert.isTrue(uniqueCandidatesBox == new Set<integer>{1});
        
        set<house> houses = game.getHouses(cell);
        for (house h :houses){
            set<integer> uq = h.getUniqueCandidatesInCell(cell);
            system.debug(loggingLEvel.warn, ' h type = ' + h.typeOfHouse + ' uq = ' + uq);
            
            if (h.typeOfHouse == house.houseTypes.BOX)
                 system.Assert.isTrue(uq == new Set<integer>{1});
            if (h.typeOfHouse == house.houseTypes.COLUMN)
                 system.Assert.isTrue(uq == new Set<integer>{1});
           	if (h.typeOfHouse == house.houseTypes.ROW)
                 system.Assert.isTrue(uq == new Set<integer>{});

        }
        
 
    }
    

    @isTest
    static void HouseMembersMinus() {
        GameData game = new GameData();
     	
        game.getCell(1,2).cellValue = 1;
        game.getCell(1,6).cellValue = 3;
        game.getCell(2,4).cellValue = 5;
        game.getCell(2,7).cellValue = 9;
        game.getCell(2,9).cellValue = 3;
        game.getCell(3,5).cellValue = 2;
        game.getCell(3,6).cellValue = 9;
        game.getCell(4,2).cellValue = 8;
        game.getCell(5,1).cellValue = 2;
        game.getCell(5,2).cellValue = 7;
        game.getCell(5,3).cellValue = 9;
        game.getCell(5,4).cellValue = 1;
        game.getCell(5,5).cellValue = 5;
        game.getCell(5,6).cellValue = 6;
        game.getCell(5,7).cellValue = 8;
        game.getCell(5,8).cellValue = 3;
        game.getCell(5,9).cellValue = 4;
        game.getCell(6,1).cellValue = 4;
        game.getCell(6,3).cellValue = 6;
        game.getCell(8,1).cellValue = 3;
        game.getCell(8,3).cellValue = 2;
        game.getCell(8,6).cellValue = 1;
        
        gameCell cell = game.getCell(5,5);//
        house rowFive = game.getHouseRow(cell);

        integer rowSize = rowFive.members.size();
        
        set<gameCell> rowMinus = rowFive.getMembersMinus(cell);
        integer rowMinusSize = rowMinus.size();

        system.debug(loggingLevel.warn, 'rowsize = ' + rowSize + ' row minus size = '  + rowMinusSize  );
        system.debug(loggingLevel.warn, 'row member size = ' + rowFive.members.size()  );

        system.assert.isTrue(rowSize > rowMinusSize);
        system.assert.isTrue(rowSize == rowFive.members.size() );
  
 
    }
    



    @isTest
    static void NakedSingleTest() {
        GameData game = new GameData();
       // game.initalizeCells();
 		
        game.getCell(4,2).cellValue = 8;
        game.getCell(5,2).cellValue = 7;
        game.getCell(5,4).cellValue = 1;
        game.getCell(5,5).cellValue = 5;
        game.getCell(5,6).cellValue = 6;
        game.getCell(5,8).cellValue = 3;
        game.getCell(6,1).cellValue = 4;
        game.getCell(6,3).cellValue = 6;
        game.getCell(8,3).cellValue = 2;
        
        gameCell cell = game.getCell(5,3);
       
        list<GameCell> cellList = new list<GameCell>();
        cellList.add(cell);
        
        system.debug(loggingLevel.warn, 'cellValue BEFORE = ' + cell.CellValue);
        game.promoteSingleCandidates(cellList);
        system.debug(loggingLevel.warn, 'cellValue AFTER  = ' + cell.CellValue);
        assert.isTrue(cell.cellValue ==9);    
    }
    
    @isTest
    static void HiddenSingleHouse() {///
        system.debug(loggingLevel.warn, 'IN NEW CELL/HOUSE unique test ' );
        GameData game = new GameData();
        game.initalizeCells();
 		
        game.getCell(1,2).cellValue = 1;
        game.getCell(1,6).cellValue = 3;
        game.getCell(2,4).cellValue = 5;
        game.getCell(2,7).cellValue = 9;
        game.getCell(2,9).cellValue = 3;
        game.getCell(3,5).cellValue = 2;
        game.getCell(3,6).cellValue = 9;
        game.getCell(4,2).cellValue = 8;
        game.getCell(5,1).cellValue = 2;
        game.getCell(5,2).cellValue = 7;
        game.getCell(5,3).cellValue = 9;
        game.getCell(5,4).cellValue = 1;
        game.getCell(5,5).cellValue = 5;
        game.getCell(5,6).cellValue = 6;
        game.getCell(5,7).cellValue = 8;
        game.getCell(5,8).cellValue = 3;
        game.getCell(5,9).cellValue = 4;
        game.getCell(6,1).cellValue = 4;
        game.getCell(6,3).cellValue = 6;
        game.getCell(8,1).cellValue = 3;
        game.getCell(8,3).cellValue = 2;
        game.getCell(8,6).cellValue = 1;
        
        gameCell cell = game.getCell(2,5);//

      
 		integer uniqueCandidate  =cell.auditUniqueCandidates();
        
        system.debug(loggingLevel.warn, 'cell candidates = ' + cell.candidates);
        system.debug(loggingLevel.warn, 'uniqueCandidate Box = ' + uniqueCandidate);

        assert.isTrue(uniqueCandidate == 1);           
 
    }
 
      @isTest
    static void SqueezeTest() {
        GameData game = new GameData();
        //game.initalizeCells();
 		
        game.getCell(1,3).cellValue = 4;
        game.getCell(1,4).cellValue = 1;
        game.getCell(1,5).cellValue = 2;
        game.getCell(1,8).cellValue = 9;
        
        game.getCell(2,3).cellValue = 9;
        game.getCell(2,7).cellValue = 6;
        
        game.getCell(3,2).cellValue = 7;
        game.getCell(3,5).cellValue = 8;
        game.getCell(3,6).cellValue = 5;
        game.getCell(3,7).cellValue = 3;
          
        gameCell cell = game.getCell(3,4);//
       
 		//integer uniqueCandidate  = game.setUniqueCandidateForCell(game.getBOX(cell), cell);
         integer uniqueCandidate  =cell.auditUniqueCandidates();
        
        system.debug(loggingLevel.warn, 'cell candidates = ' + cell.candidates);
        system.debug(loggingLevel.warn, 'uniqueCandidate Box = ' + uniqueCandidate);
        
        game.printGame(true);
        
        assert.isTrue(uniqueCandidate == 9);    
 
    }
    
    

      @isTest
    static void CrossHatchRowTest() {
        GameData game = new GameData();
      	
        game.getCell(2,2).cellValue = 2;
        game.getCell(2,4).cellValue = 5;
        game.getCell(2,5).cellValue = 1;
        game.getCell(2,7).cellValue = 9;
        game.getCell(2,9).cellValue = 3;
        
        game.getCell(9,1).cellValue = 6;
        game.getCell(6,3).cellValue = 6;
        game.getCell(5,6).cellValue = 6;
        
         
        gameCell cell = game.getCell(2,8);//
       
 		//integer uniqueCandidate  = game.setUniqueCandidateForCell(game.getRow(cell), cell);
        integer uniqueCandidate  =cell.auditUniqueCandidates();
        
        system.debug(loggingLevel.warn, 'cell candidates = ' + cell.candidates);
        system.debug(loggingLevel.warn, 'uniqueCandidate Row = ' + uniqueCandidate);
        
        assert.isTrue(cell.cellValue == 6);    
 
        
    }
    
@isTest
    static void CrossHatchCornerTest() {
        GameData game = new GameData();
        //game.initalizeCells();
 		
        game.getCell(2,2).cellValue = 2;
        game.getCell(2,4).cellValue = 5;
        game.getCell(2,5).cellValue = 1;
        game.getCell(2,7).cellValue = 9;
        game.getCell(2,8).cellValue = 6;
        game.getCell(2,9).cellValue = 3;
        
        game.getCell(5,1).cellValue = 2;
        game.getCell(5,2).cellValue = 7;
        game.getCell(5,3).cellValue = 9;
        game.getCell(5,4).cellValue = 1;
        game.getCell(5,5).cellValue = 5;
        game.getCell(5,6).cellValue = 6;
        game.getCell(5,7).cellValue = 8;
        game.getCell(5,8).cellValue = 3;
        game.getCell(5,9).cellValue = 4;
        
        game.getCell(6,1).cellValue = 4;
        game.getCell(6,3).cellValue = 6;
		game.getCell(6,8).cellValue = 7;
        
        game.getCell(8,1).cellValue = 3;
        
        game.getCell(9,1).cellValue = 6;
        game.getCell(9,4).cellValue = 3;
        game.getCell(9,8).cellValue = 9;
        
       // game.printGame(true);   
        
        gameCell cell = game.getCell(7,7);//
       
 		//integer uniqueCandidate  = game.setUniqueCandidateForCell(game.getBox(cell), cell);
        integer uniqueCandidate  =cell.auditUniqueCandidates();
        
        system.debug(loggingLevel.warn, 'cell candidates = ' + cell.candidates);
        system.debug(loggingLevel.warn, 'uniqueCandidate Box = ' + uniqueCandidate);
        
        assert.isTrue(uniqueCandidate == 3);    
    
    }
    
    static testmethod void lockedCandidates1() {
        
        string lockedCandidatesDemo = '000023000004000100050084090001070902093006000000010760000000000800000004060000587';
        
        GameData gd = new GameData();
        gd.populateGame(lockedCandidatesDemo, false);
        
        gameCell c = gd.getCell(1, 4);//
        Set<GameCell> columnCells = gd.columns.get(c.c);
        Set<GameCell> boxCells = gd.boxes.get(c.box);
        Set<GameCell> rowCells = gd.rows.get(c.r);
        gd.applyBoxLineInteraction(c, boxCells, columnCells);
        
        
        gameCell cell = gd.getCell(7, 4);//
        system.debug(loggingLevel.warn, 'cell candidates = ' + cell.candidates);
        boolean contains = !cell.candidates.contains(1);
        assert.isTrue(contains);
        
        cell = gd.getCell(8, 4);//
        system.debug(loggingLevel.warn, 'cell candidates = ' + cell.candidates);
        contains = !cell.candidates.contains(1);
        assert.isTrue(contains);
        
        cell = gd.getCell(9, 4);//
        system.debug(loggingLevel.warn, 'cell candidates = ' + cell.candidates);
        contains = !cell.candidates.contains(1);
        assert.isTrue(contains);
        
    }
    
    static testmethod void unlockedSingle() { 
        
        string unlockedSingleDemo = '054007690000040000009000000000158004005230008008000150000400003006080209002005000';
      
        GameData gd = new GameData();
        gd.populateGame(unlockedSingleDemo, false);
        
        
        gameCell c = gd.getCell(4, 8);//
        system.debug(loggingLevel.warn, 'cell box = ' + c.box + ' cell row = ' + c.r); 
        Set<GameCell> columnCells = gd.columns.get(c.c);
        Set<GameCell> boxCells = gd.boxes.get(c.box);
        Set<GameCell> rowCells = gd.rows.get(c.r);
		gd.applyBoxLineInteraction(c, boxCells, rowCells); 
        
        gd.printGame(true);
        
        assert.isTrue(!gd.getCell(4, 3).candidates.contains(3));//3 should be gone

		gd.promoteSingleCandidates((new list<gameCell>(rowCells)));
        
        gameCell gc43 = gd.getCell(4, 3);
        system.debug(loggingLevel.warn, 'cell gc43 = ' + gc43.cellValue + ' ' + gc43.candidates);
        assert.isTrue(gc43.cellValue == 7);
       
         
        gameCell gc23 = gd.getCell(2, 3);
        //integer uniCan  = gd.setUniqueCandidateForCell(gd.getColumn(gc23), gc23);
        integer uniCan  =gc23.auditUniqueCandidates();
        
        system.debug(loggingLevel.warn, 'cell gc23 = ' + gc23.cellValue + ' ' + gc23.candidates );
        assert.isTrue(uniCan == 3);
          
    }
    
    static testmethod void LockedCandidatesType2() { 
        
        string lockedCandidatesType2data = '500200010001900730000000800050020008062039000000004300000000000080467900007300000';
       
        GameData gd = new GameData();
        gd.populateGame(lockedCandidatesType2data, false);
        
        gameCell c = gd.getCell(7, 7);//
        system.debug(loggingLevel.warn, 'cell box = ' + c.box + ' cell row = ' + c.r); 
        Set<GameCell> columnCells = gd.columns.get(c.c);
        Set<GameCell> boxCells = gd.boxes.get(c.box);
        Set<GameCell> rowCells = gd.rows.get(c.r);
		gd.applyBoxLineInteraction(c, columnCells, boxCells); 
        
        system.debug(loggingLevel.warn, 'LOCK2: ');
        gd.printGame(true);  
        
        //two 2s, 7 without 2
        assert.isTrue( gd.getCell(7, 7).candidates.contains(2));//2
        assert.isTrue(!gd.getCell(7, 8).candidates.contains(2));// 
        assert.isTrue(!gd.getCell(7, 9).candidates.contains(2));// 
        assert.isTrue(!gd.getCell(8, 7).candidates.contains(2));// 
        assert.isTrue(!gd.getCell(8, 8).candidates.contains(2));// 
        assert.isTrue(!gd.getCell(8, 9).candidates.contains(2));// 
        assert.isTrue( gd.getCell(9, 7).candidates.contains(2));// 
        assert.isTrue(!gd.getCell(9, 8).candidates.contains(2));// 
        assert.isTrue(!gd.getCell(9, 9).candidates.contains(2));//     
    }
    
    
    static testmethod void nakedPair() { 
        system.debug(loggingLevel.warn, 'NAKED PAIR TEST ');
        
        string nakedPairData = '005160000600073000300005706000030691139756482862490000401000005000500008000007200';

        GameData gd = new GameData();
        gd.populateGame(nakedPairData, false);
        
        gameCell c = gd.getCell(3, 3);//
        system.debug(loggingLevel.warn, 'cell box = ' + c.box + ' cell row = ' + c.r); 
        Set<GameCell> columnCells = gd.columns.get(c.c);
        Set<GameCell> boxCells = gd.boxes.get(c.box);
        Set<GameCell> rowCells = gd.rows.get(c.r);
		       
        set<integer> thePair = new set<integer>{4,8};
        
        //CONTAINS
        assert.isTrue(gd.getCell(1, 2).candidates.containsAll(thePair));// 
        assert.isTrue(gd.getCell(2, 2).candidates.containsAll(thePair));// 
        assert.isTrue(gd.getCell(3, 2).candidates.containsAll(thePair));// 
         
        gd.nakedSubsets(boxCells, 2);
        
        //NOT CONTAINS!!
        assert.isTrue(!gd.getCell(1, 2).candidates.containsAll(thePair));// 
        assert.isTrue(!gd.getCell(2, 2).candidates.containsAll(thePair));// 
        assert.isTrue(!gd.getCell(3, 2).candidates.containsAll(thePair));// 
        
        
    }
        
    
    @isTest
    static  void nakedTriple() { 
        system.debug(loggingLevel.warn, 'NAKED TRIPLE TEST ');
        
        string nakedTripleData = '230500007015000020080200006150000064890100000000050910040815600061030000008006401';
         
        GameData gd = new GameData();
        gd.populateGame(nakedTripleData, false);    

        gd.printGame(true);  

        Set<GameCell> testRow = gd.getRow(3);
        GameCell testCell = gd.getCell(3, 8);

        Assert.isTrue(testCell.candidates.contains(4), 'no starting candidate');
        gd.nakedSubsets(testRow, 3);

        gd.printGame(true);  

        Assert.isFalse (testCell.candidates.contains(4), 'candidate not removed');


    }
    
    
    @isTest
    static void testNakedTripleSubsets () {
    	string testTriple = '700605029000800036001000074007008205090000483308000700279000658010789342800526917';
        string testQuad='476050903132000085598000007800060009007405308300080002700000291280000576001070834';
        
        system.debug(loggingLevel.warn, 'IN NEW TEST testNakedTripleSubsets   '); 
        
        GameData gd = new GameData();
        gd.populateGame(testTriple, false);    

        gd.printGame(true);  
        
        house h = new house(gd.getRow(3));
        
        map<set<integer>, set<gameCell>> cs2cs = h.getCandidatesToCells();
        
        system.debug(loggingLevel.warn, 'cs2cs' );
        
        set<integer> testKey = new set<integer>{3,2,9} ;
        Assert.isTrue(cs2cs.get(testKey).size()==2);
        
        
        system.debug(loggingLevel.warn, 'cs2cs SECOND TEST' ); 
        
        GameData gdq = new GameData();
        gdq.populateGame(testQuad, false);    

        gdq.printGame(true);  
        
        house hq = new house(gdq.getbox(8));
        
        list<gameCell> cellsBySize = new list<gameCell>();
        cellsBySize.addAll(gdq.getbox(8) );
        cellsBySize.sort(new GameCell.SizeCompare());
        for (gameCell g :cellsBySize){
            system.Debug(loggingLevel.warn, 'sort by size= ' + g.candidates);
            
        }
        
        
        map<set<integer>, set<gameCell>> cs2csQ = hq.getCandidatesToCells();
        
        system.debug(loggingLevel.warn, 'cs2csQ' );
        
        set<integer> quadKey = new set<integer>{1,3,4,9} ;
        
        system.debug(loggingLevel.warn, 'map loop:' );
        for (set<integer> qk : cs2csQ.keySet()) {
            system.Debug(loggingLevel.warn,' quad loop = ' + qk + 'size = ' + cs2csQ.get(qk).size() );
            
        }
       	system.Debug(loggingLevel.warn,' quadkey = ' + quadKey + 'size = ' + cs2csQ.get(quadKey).size()  );
             
        Assert.isTrue(cs2csQ.get(quadKey).size() ==4 );
        
    }
    
    
    
    @isTest
    static void testInitializeCells() {
        GameData gameData = new GameData();
       // gameData.initalizeCells();
        System.assertEquals(81, gameData.getCells().size(), 'Incorrect number of cells initialized');
    }
    
    @isTest
    static void testGetCell() {
        GameData gameData = new GameData();
       // gameData.initalizeCells();
        GameCell cell = gameData.getCell(1, 1);
        System.assertNotEquals(null, cell, 'Cell retrieval failed');
    }
    
    @isTest
    static void testGetColumn() {
        GameData gameData = new GameData();
        gameData.initalizeCells();
        Set<GameCell> columnCells = gameData.getColumn(1);
        System.assertNotEquals(null, columnCells, 'Column retrieval failed');
    }
    
    @isTest
    static void testGetRow() {
        GameData gameData = new GameData();
        gameData.initalizeCells();
        Set<GameCell> rowCells = gameData.getRow(1);
        System.assertNotEquals(null, rowCells, 'Row retrieval failed');
    }
    
    @isTest
    static void testGetBox() {
        GameData gameData = new GameData();
        gameData.initalizeCells();
        Set<GameCell> boxCells = gameData.getBox(1);
        System.assertNotEquals(null, boxCells, 'Box retrieval failed');
    }
    
 
}