@isTest
public class SudokuTestXWing {
    
    @isTest
    //https://www.sudocue.net/guide.php#XWing
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
         
        map<list<integer>, Set<GameCell>>  candidateHouseFrequency = SudokuTestXWing.makeFrequencyMap(gd.colHouses);
        integer filterSize = 2;

        //for each candidate
        //find houses with n cells
        //if there are n houses!!!
        //test the coordinates
        //either    rows different AND columns equal
        //OR        columns different AND rows equal


        //filter frequencyMapByCandidateAndSize() 
        for (integer c :GameCell.allValues ){ 
            Set<GameCell> xcells = new Set<GameCell>();
            set<integer> rowNumbers = new set<integer>();
            set<integer> colNumbers = new set<integer>();
            set<list<integer>> chKeys = SudokuTestXWing.filterFrequencyMapByCandidateAndSize(candidateHouseFrequency, c, filterSize);
            if (chKeys.size() == filterSize) {
                for (list<integer> key :chKeys) {
                    xcells.addAll(candidateHouseFrequency.get(key));
                }
            }
            for (gameCell gc : xcells){
                rowNumbers.add(gc.r);
                colNumbers.add(gc.c);
            }

            if (rowNumbers.size() == filterSize && colNumbers.size() == filterSize) {
                system.debug(loggingLevel.warn, 'XWing found c= '  + c + ', rows: '  +  rowNumbers + ' colNumbers ' + colNumbers );
            }


        }
    }

    private static set<list<integer>> filterFrequencyMapByCandidateAndSize(
        map<list<integer>, Set<GameCell>>  candidateHouseFrequency, integer c, integer filterSize){
        set<list<integer>> returnKeys = new set<list<integer>> ();

        for (integer h : GameCell.allValues) {  
            list<integer> key = new list<integer> {c,h};
            if (candidateHouseFrequency.get(key).size() == filterSize){
                returnKeys.add(key);
            }
        }

        return returnKeys;

    } 


    private static map<list<integer>, Set<GameCell>>  makeFrequencyMap( map<integer, house> houses  ) {
        //candidate, house, cells
        map<list<integer>, Set<GameCell>>  returnCandidateHouseFrequency = new map<list<integer>, Set<GameCell>> ();

 
        for (house ch :houses.values()){
            map<integer, set<gameCell>> candidatesToCells = ch.getCellsByCandidate();

            for (integer c :candidatesToCells.keySet() ){
                //if (returnCandidateHouseFrequency.containsKey(c))...
                list<integer> candidateHouse =  new list<integer>{c, ch.position};
                returnCandidateHouseFrequency.put(candidateHouse, candidatesToCells.get(c) );

            }

        }

        return returnCandidateHouseFrequency;

    }


}