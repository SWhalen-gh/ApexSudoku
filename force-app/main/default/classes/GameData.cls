public with sharing class GameData {

    static final integer START = 1; 
    static final integer GAMESIZE = 9; 
    
    public id recordId;
    public string gameDataString;
     
    @testVisible
    Private map<rc, gameCell> allCells = new map<rc, gameCell>();
    @testVisible
    Private map<integer, set<gameCell>> columns = new map<integer, set<gameCell>>();
    @testVisible
    Private map<integer, set<gameCell>> rows = new map<integer, set<gameCell>>(); 
    @testVisible
    Private map<integer, set<gameCell>> boxes = new map<integer, set<gameCell>>(); 
    
    @testVisible
    Private map<integer, house> colHouses = new map<integer, house>();
    @testVisible
    Private map<integer, house> rowHouses = new map<integer, house>(); 
    @testVisible
    Private map<integer, house> boxHouses = new map<integer, house>(); 
    
    private set<house> allHouses = new set<house>();

    
    public map<integer, set<gameCell>>  getRows() {
        return this.rows;
    }
     

    public string printGameXML() {
    
        Integer cpuCycles = system.limits.GetCPUTime();
        string solvedPuzzle = '<solution>';
        //solvedPuzzle += '<duration>' + cpuCycles + '</duration>';
        for (integer r = START; r <= GAMESIZE; r++ ) {
            string rowString = '<row>';
            for (integer c = START; c<= GAMESIZE;c++ ) {
               gameCell cell = getCell(r, c);
               rowString +=  '<cell>' + cell.cellValue  + '</cell>'   ;
            }
            rowString += '</row>';
            solvedPuzzle+= rowString;
             
        }
    
        solvedPuzzle += '</solution>';
        return solvedPuzzle;

    }
    public string printGame(boolean withCandidates) {
    
        string returnS81 = '';

        for (integer r = START; r <= GAMESIZE; r++ ) {
            string rowString = '';
            for (integer c = START; c<= GAMESIZE;c++ ) {
               gameCell cell = getCell(r, c);
                string candidateString= '';
                if (withCandidates && cell.cellValue ==0) candidateString =' (' + cell.candidates + ')';
               rowString += cell.cellValue + candidateString;
            }
            returnS81+= rowString;
            system.debug(loggingLevel.warn, 'r = ' + r + ' ' + rowString);
        }
    
        return returnS81;

    }
    
    public gameCell getCell(integer r,integer c) {
        return allCells.get(new rc(r, c));
    }
    
    public  map<rc, gameCell> getCells () {
       system.debug(loggingLevel.warn, 'in GET CELLS!');
       return allCells.Clone(); 
    }
    
    //public void setValue
        
    public set<gameCell> getColumn(integer column) {
        return columns.get(column);
        
    }
     
    public set<gameCell> getColumn(gameCell cell) {
        return columns.get(cell.c);
        
    }
    
    public set<gameCell> getRow (integer row) {
        return rows.get(row);
        
    }
    public set<gameCell> getRow (gameCell cell) {
        return rows.get(cell.r);
        
    }
    
    public set<gameCell> getBox (integer box) { 
        return boxes.get(box);  
    }
    public set<gameCell> getBox (gameCell cell) {
        return boxes.get(cell.box);
        
    }
    
    
    public set<house> getHouses (gameCell cell) {     
        set<house> returnHouses = new set<house>();    

        returnHouses.add(rowHouses.get(cell.r));
        returnHouses.add(colHouses.get(cell.c));
        returnHouses.add(boxHouses.get(cell.box));
         
        return returnHouses;
    } 
    
    public house getHouseBox (gameCell cell) {     
       
        return boxHouses.get(cell.box);
       
    } 
    public house getHouseRow (gameCell cell) {     
       
        return rowHouses.get(cell.r);
       
    } 
    
    public house getHouseColumn (gameCell cell) {     
       
        return colHouses.get(cell.c);
       
    } 
    

    

           
    public set<gameCell> auditUniqueCandidates(gameCell cell) {
        set<gameCell> changedCells = new set<gameCell>();
        
        if (cell.cellValue>0) {
            return changedCells; //guard clause; nothing to do
        }

        // if a cell has a unique candidate for a house, make it the cell value
        integer uniqueValue = cell.auditUniqueCandidates();
          
        if (cell.cellValue>0) changedCells.add(cell);
        
        return changedCells;
       
    }
     
    @testVisible
    private set<gameCell> promoteSingleCandidates(list<GameCell> cells) {
        set<gameCell> changedCells = new set<gameCell>();   
        for (gameCell c : cells) {
            if (c.candidates.size() == 1){
                integer vvv = c.candidates.iterator().next();
                
                this.setValue(c, vvv, 'promote single');
                
                changedCells.add(c);   
                 
            }
        }
        return changedCells;///
        
    }
    
    private void setValue(gameCell c, integer newValue, string source){
        
        c.cellValue = newValue;
        
        system.debug (loggingLevel.warn,  source + ' cellValue= ' 
                          + c.cellValue + ' at R= ' + c.r + ' C= '+ c.c);
        
    }

       
    public set<gameCell> removeKnownValueFromCandidates(gameCell knownCell) {
        set<gameCell> changedCells = new set<gameCell>();  
      
        for (house h : knownCell.getHouses()) {  
            changedCells.addAll(h.removeKnownValueFromCandidates(knownCell));
        }
                  
        return changedCells; 
    }

    
    public string solve(string s81) {
        string returnResult = '';
        this.populateGame(s81, true);

        //returnResult = this.printGameXML();
        returnResult = this.printGame(false);

        return returnResult;
    }

    public gameData() {

        this.initalizeCells();
    }

    public gameData(string s81, boolean solve) {

        this.initalizeCells();
        this.populateGame(s81, solve);
    }

    
    public void initalizeCells() {
        map<rc, gameCell> returnCells = new map<rc, gameCell> (); 
        
        set<gameCell> setCells = new set<gameCell>();
        
        for (integer r = START; r <= GAMESIZE; r++ ) {
            for (integer c = START; c<= GAMESIZE;c++ ) {
                setCells.add(new GameCell(r, c, this));   
                
            }
        }
        
        makeMaps(setCells);
          
    }
    
    public void populateGame(string s81, boolean solve){
        
        integer l = s81.length();
        if (s81.length() > 100 ) {//allowing for some spaces
            system.debug(loggingLevel.warn,  'input string is too big ');
            return;
        }
        
        string trim81 = s81.trim();
        if (trim81.length() <> 81 ) {
            system.debug(loggingLevel.warn,  'input string is too big ');
            return;
        }
                 
        if (!trim81.isNumeric()) { 
             system.debug(loggingLevel.warn,  'input string is not numbers');
             return;
        }
        s81 = null;
        
        list<string> numbers = trim81.split('');
        for (integer index=0 ;index < l; index++) { 
            integer r = (index / 9) + 1; // # Calculate row index
            integer c = (math.mod(index, 9)) + 1 ; // # Calculate column index
            integer digit = Integer.valueOf(numbers[index]);
            gameCell cell = getCell(r, c);
            if (digit > 0) {
                cell.cellValue = digit;
                removeKnownValueFromCandidates(cell);
            }
            //system.debug(loggingLevel.warn, 'index = ' + index +  ' row =  ' + r + ' col = '+ c + ' = ' + digit);
        }
        
        system.debug(loggingLevel.warn,  'printing values with candidates removed:');
        this.printGame(true);
        
         if (!solve) return;
        
        system.debug(loggingLevel.warn,'start auditUniqueCandidates loop');       
        set<gameCell> allChangedCells = new set<gameCell>();
        for (gameCell c :allCells.values()){
            set<gameCell> changedCells = auditUniqueCandidates(c);   
            allChangedCells.addall(changedCells);
            if (changedCells.size() >0 ) {
                system.debug(loggingLevel.warn, 'cell ' + c + ' changed these: ' + changedCells);
                
            }
        }
         
       printGame(false);
          
       auditBoard();
       system.debug(loggingLevel.warn, 'AFTER AUDITgame state: ');     
       printGame(false);
      
        
    }
    
    private void  auditBoard() {
        system.debug(loggingLevel.warn,'in audit board');
        
        printGame(true);
        
        set<gameCell> allChangedCells = new set<gameCell>();   
    
        for (gameCell cell :allCells.values()){

            allChangedCells.addAll(applyBoxLineInteraction(cell, cell.boxHouse.members, cell.colHouse.members));
            allChangedCells.addAll(applyBoxLineInteraction(cell, cell.boxHouse.members, cell.rowHouse.members));
            allChangedCells.addAll(applyBoxLineInteraction(cell, cell.rowHouse.members, cell.boxHouse.members));
            allChangedCells.addAll(applyBoxLineInteraction(cell, cell.colHouse.members, cell.boxHouse.members));
             
        }
     
        
        allChangedCells.addAll(promoteSingleCandidates(this.allCells.values()));
         
        
        for (Set<GameCell> house : boxes.values()) {
            allChangedCells.addAll(nakedSubsets(house, 2));
        }
        
        for (Set<GameCell> house : columns.values()) {
            allChangedCells.addAll(nakedSubsets(house, 2));
        }
        
        for (Set<GameCell> house : rows.values()) {
            allChangedCells.addAll(nakedSubsets(house, 2));
        }
        

        
 //needs work:
 
        for (Set<GameCell> house : columns.values()) {
            allChangedCells.addAll(nakedSubsets(house, 3));
        }
        for (Set<GameCell> house : rows.values()) {
            allChangedCells.addAll(nakedSubsets(house, 3));
        }
        for (Set<GameCell> house : boxes.values()) {
            allChangedCells.addAll(nakedSubsets(house, 3));
        }
       
        
        for (Set<GameCell> house : columns.values()) {
            allChangedCells.addAll(simpleHiddenSets(house, 2));
        }
       
        for (Set<GameCell> house : rows.values()) {
         allChangedCells.addAll(simpleHiddenSets(house, 2));
            
        }
         
        for (Set<GameCell> house : boxes.values()) {
            allChangedCells.addAll(simpleHiddenSets(house, 2));
        }    
     
          
        for (Set<GameCell> house : columns.values()) {
            allChangedCells.addAll(simpleHiddenSets(house, 3));
        }
        for (Set<GameCell> house : rows.values()) {
            allChangedCells.addAll(simpleHiddenSets(house, 3));
        }
        for (Set<GameCell> house : boxes.values()) {
            allChangedCells.addAll(simpleHiddenSets(house, 3));
        }        
      
        
                
        for (gameCell c :allCells.values()){
            set<gameCell> changedCells = auditUniqueCandidates(c);   
            allChangedCells.addall(changedCells);
            if (changedCells.size() >0 ) {
                system.debug(loggingLevel.warn, 'cell r: ' + c.r + ' cell c: ' + c.c + ' changed these: ' + changedCells);
                
            }
       }
        
         
        if (allChangedCells.size()>0) {
            system.debug(loggingLevel.warn, 'enter audit board AGAIN');
            auditBoard();
        }
         
    }
    

    Public void xwingN(gameCell cell, integer wingSize) {
    //assume wingSize = 2   
        house colHouse = cell.colHouse;
        house rowHouse = cell.rowHouse;   
        
        //house, candidate, occurances
        //h, c, occurances
        //2,1,2
       	//6,1,2
       	//or...
       	//occurances, c, houses
       	//2,1,(2,6)
       	//or...
       	//c,  house, occurances
       	//1, 2,2
       	//1,6,2
       	map<list<integer>, set<gameCell> > cho = new map<list<integer>, set<gameCell> >();
          
        map<integer, map<integer, set<gameCell>>> 
            hco = new map<integer, map<integer,set<gameCell>>>  ();
 
        for (integer c : GameCell.allValues){
            for (integer h : GameCell.allValues){ 
                cho.put(new list<integer>{c,h}, null ); //prep empty map
            }
        } 
        
        
        map<integer, set<gameCell>> allCandidateToCells = new map<integer, set<gameCell>>(); 
        for (integer i : GameCell.allValues){
            allCandidateToCells.put(i, new set<gameCell>() ); //prep empty map
        }
            
        for (house h : this.rowHouses.values() ) {
        //get candidates to cells    
            map<integer, set<gameCell>> houseCandidatesToCells = h.getCellsByCandidate();
            hco.put(h.position, houseCandidatesToCells );  
            for (integer c : houseCandidatesToCells.keySet()){    
                
                cho.put(new list<integer>{c,h.position},  houseCandidatesToCells.get(c)  );
            }
             
        }
        
        
       // cho.find(x.c== 2).count = 2 
        set<List<integer>> countMatch = new set<List<integer>> ();
        for (integer c :gameCell.allValues) {
        	for (integer h :gameCell.allValues) {
                list<integer> ch = new list<integer> {c,h};
                    if (cho.get(ch).size() ==2 ){
                        
                    }
            
        	}         	 
        } 
    
    }

    //hidden pair, triple, quad
    public set<GameCell> SimpleHiddenSets(set<GameCell> house, integer setSize) {
    //first make a map of map<integer, set<gameCell>> candidates to their cells
    //then look for candidates that are in only setSize cells
    //then look for candidates that are in the same cells
        Set<GameCell> changedCells = new Set<GameCell>();
        //boolean quits;
        //quits = (changedCells.size() ==0 );
        
        map<integer, set<gameCell>> candidateToCells = new map<integer, set<gameCell>>();
        for (gameCell cell : house){
            for (integer candidate :cell.candidates){ 
                if (!candidateToCells.containsKey(candidate)) 
                    candidateToCells.put(candidate, new set<gamecell>()) ;              
                candidateToCells.get(candidate).add(cell);
                 
            }
        }     
        
        //remove candidates from map that are in too many cells
        list<integer> removeCandidates = new list<integer>();
        for (integer candidate : candidateToCells.keySet()){
            if (candidateToCells.get(candidate).size() <> setSize) {
                removeCandidates.add(candidate);
            }
        }
        
        for (integer rc :removeCandidates){
            candidateToCells.remove(rc);
        }
        
        if ( candidateToCells.keySet().size() <> setSize) return changedCells;
        
  
        //find candidates in the same cells:
        
        //need to find:
        //are there 2 gamecells that have 2 candidates in common
        //or find 2 candidates that appear in 2 gamecells
        //make combinations: c1,c2
        //count cells that have the combinations
        set<gameCell> gameCellWithAllKeys  = new set<gameCell>();
            for (integer i : candidateToCells.keyset()  ){
                set<gameCell> sgc = candidateToCells.get(i);
                for (gamecell gc :sgc ){
                    if (gc.candidates.containsAll(candidateToCells.keySet())){
                        gameCellWithAllKeys.add(gc);
                    }
                }
            }
         
        system.debug(loggingLevel.warn, 'hidden2 gameCellWithAllKeys '+ gameCellWithAllKeys );
        
        if (gameCellWithAllKeys.size() <> setSize )  return changedCells;
        
        for (gamecell gc : gameCellWithAllKeys){
            if (gc.candidates.size()  == setSize)   continue;
            boolean removed = gc.candidates.retainAll(candidateToCells.keySet());
            if (removed) changedCells.add(gc);
            
        }
        
        system.debug(loggingLevel.warn, 'hidden2 changedCells: '+ changedCells );
        return changedCells;
        
    }
        
    
    public Set<GameCell> nakedSubsets(set<GameCell> house, integer setSize) {
        Set<GameCell> changedCells = new Set<GameCell>();
         
        map<set<integer>, integer> setsCount = new map<set<integer>, integer>();
        for (gameCell cell : house){
            if (cell.candidates.size() == setSize) { //count
                integer thisCount = setsCount.get(cell.candidates);// should include subsets
                if(thisCount == null) thisCount = 0;
                thisCount++;
                setsCount.put(cell.candidates, thisCount);
         
            }
        }
        
        for (set<integer> s :setsCount.keyset()) {//remove infrequent sets
            if (setsCount.get(s) <  setSize ) setsCount.remove(s);
        }
        
        if (setsCount.size() == 0) return changedCells; // guard clause. nothing to do
        system.debug(loggingLevel.warn, 'subsetdata = '+ setsCount );
        
        for (set<integer> s : setsCount.keySet()){//remove set from other cells
            for (gameCell cell : house){
                if (cell.candidates.size() > setSize) {//remove them from bigger sets
                    boolean removed = cell.removeCandidates(s);
                    if (removed)  changedCells.add(cell);
                }
            }
             
        }
        system.debug(loggingLevel.warn, 'subsets removed = '+ changedCells.size() );
        return changedCells;
    }
    
//box to row, box to col...row to box, col to box
public Set<GameCell> applyBoxLineInteraction(GameCell cell, set<GameCell> sourceCells, set<GameCell> targetCells) {
    Set<GameCell> changedCells = new Set<GameCell>();
      
    if (cell.cellValue >0 ) return changedCells;// guard clause
    
    // Get the overlapping cells between the column and the box
    Set<GameCell> overlappingCells =  new Set<GameCell>(targetCells);
    overlappingCells.retainAll(sourceCells);
    
    // Calculate rest of the box and rest of the column
    Set<GameCell> restOfSource = new Set<GameCell>(sourceCells);
    restOfSource.removeAll(targetCells);
    
    Set<GameCell> restOfTarget = new Set<GameCell>(targetCells);
    restOfTarget.removeAll(sourceCells);
     //system.debug(loggingLevel.warn, 'hidden method source cell = ' + cell);
    // Calculate candidates that are unique to overlapping cells
    Set<Integer> candidatesInOverlap = new Set<Integer>();
    for (GameCell cellInOverlap : overlappingCells) {
        candidatesInOverlap.addAll(cellInOverlap.candidates);
    }
   
    candidatesInOverlap.removeAll(restOfSource.isEmpty() ? new Set<Integer>() : getDistinctCandidates(restOfSource));
    if (candidatesInOverlap.isEmpty()) return changedCells;
    //system.debug(loggingLevel.warn, 'original cell R = ' + cell.r + ' c = ' + cell.c);  
    // Remove the unique candidates from the rest of the target cells
    for (GameCell targetCell : restOfTarget) {
        boolean removed = targetCell.removeCandidates(candidatesInOverlap);//candidatesToRemove
        if (removed) changedCells.add(targetCell);
        
    }
      
    return changedCells;
}
    
    // Helper method to get distinct candidates from a set of cells
    private Set<Integer> getDistinctCandidates(Set<GameCell> cells) {
        Set<Integer> distinctCandidates = new Set<Integer>();
        for (GameCell cell : cells) {
            distinctCandidates.addAll(cell.candidates);
            if (cell.cellValue> 0) distinctCandidates.add(cell.cellValue);
        }
        
        return distinctCandidates;
    }
     
    private void makeMaps(set<gameCell> setCells){
        columns = new map<integer, set<gameCell>>();
        rows = new map<integer, set<gameCell>>(); 
        boxes = new map<integer, set<gameCell>>(); 
    
        this.colHouses = new map<integer, house>();
        this.rowHouses = new map<integer, house>(); 
        this.boxHouses = new map<integer, house>();
        this.allHouses = new set<house>();
        
        for (gameCell cell: setCells) {
            allCells.put(new rc(cell.r,cell.c), cell); 
            
            set<gameCell> col= columns.get(cell.c);// 
            if (col == null) col = new set<gameCell>();
            col.add(cell);
            columns.put(cell.c, col);
             
            house ch = this.colHouses.get(cell.c);
            if (ch == null) ch = new house(house.houseTypes.COLUMN, cell.c);
            ch.members.add(cell);
            this.colHouses.put(cell.c, ch);

            set<gameCell> row = rows.get(cell.r);// 
            if (row == null) row = new set<gameCell>();
            row.add(cell);
            rows.put(cell.r, row); 

            house rh = this.rowHouses.get(cell.r);
            if (rh == null) rh = new house(house.houseTypes.ROW, cell.r);
            rh.members.add(cell);
            this.rowHouses.put(cell.r, rh);


            set<gameCell> box = boxes.get(cell.box);//  
            if (box == null) box = new set<gameCell>();
            box.add(cell);
            Boxes.put(cell.box, box); 

            house bh = this.boxHouses.get(cell.box);
            if (bh == null)  bh = new house(house.houseTypes.BOX, cell.box);
            bh.members.add(cell);
            this.boxHouses.put(cell.box, bh);

            cell.rowHouse = rh;
            cell.colHouse = ch;
            cell.boxHouse = bh;
                 
        }
         
    
        allHouses.addAll(rowHouses.values());
        allHouses.addAll(colHouses.values());
        allHouses.addAll(boxHouses.values());


    }
    
    public void save(string gameName) {
        String JSONcells = JSON.serialize(this.allCells.values());
         
        sudokuGame__c s = new sudokuGame__c();
        
        s.name = gameName;
        s.gameState__c = JSONcells;
        
        insert s;
        system.debug(loggingLEvel.warn, 'state =  '+ JSONcells); 
    }
    
    public void load(string gameName) {
        
        sudokuGame__c s = [SELECT id, name, gameState__c 
                           FROM sudokuGame__c 
                           WHERE name = :gameName
                           LIMIT 1 ];
        this.recordId = s.id;        
        
        this.gameDataString = s.gameState__c;
         
        set<GameCell>   ddd =  (set<GameCell>)JSON.deserialize(
               s.gameState__c, set<GameCell>.class);
          
        makeMaps(ddd);
    }
            
}