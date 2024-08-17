public class GameCell { 
    //about cells:
    //a cell knows its parent containers, meaing the row, column, and box that it belongs to.
    //collectively, rows, columns, and boxes are referred to as houses, 
    //just because one collective term is sometimes convenient.
    //There are times when it is helpful to be able to loop through a cells houses.
    //fyi generally:
	//https://salesforce.stackexchange.com/questions/111419/can-built-in-exceptions-be-thrown 
    public class SizeCompare implements Comparator<GameCell> { 
        //this is desc. Big sizes first.
       public Integer compare(GameCell e1, GameCell e2) {
            if(e1?.candidates.size() == null && e2?.candidates.Size() == null) {
                return 0;
            } else if(e1?.candidates.size() == null) { 
                return 1; 
            } else if(e2?.candidates.size() == null) {
                return -1;
            }      
           	if (e1.candidates.size() == e2.candidates.size() ) return 0;
           
          	if (e1.candidates.size() > e2.candidates.size() ) return -1;
               
          	if (e1.candidates.size() < e2.candidates.size() ) return 1;
            
           return 0;
       }
    }
     
    public static final set<integer> allValues = new set<integer> {1,2,3,4,5,6,7,8,9};   
    public integer r { public get; private set; } 
    public integer c { public get; private set; }  
    public integer box { public get; private set; }  
    
    public gameData game; 
    
    public house rowHouse { public get; public set; }  
    public house colHouse { public get; public set; }   
    public house boxHouse { public get; public set; }       
     
    //private set<house> houses = new set<house>();
    public set<house> getHouses() {
    	return new set<house> {rowHouse, colHouse, boxHouse};
    }

    public integer auditUniqueCandidates() {
        integer returnUniqueCandidate= null;
        for (house h :this.getHouses()) {///
            integer v = h.getUniqueCandidateInCell(this);
            if ((v ?? 0) > 0) {
                this.cellValue = v;
                returnUniqueCandidate = v;
                break;
            }
        }
        return returnUniqueCandidate;
    }

      
	public Set<Integer> candidates {
        public get {
            return this.candidates;
        }
        private set {
            this.candidates = value;
        }
   	}
     
	
    public boolean removeCandidates (integer removeCandidate) {
        
        set<integer> removeCandidates = new set<integer>();
        removeCandidates.add(removeCandidate);
        return removeCandidates(removeCandidates);
        
    }
    
    public boolean removeCandidates (set<integer> removeCandidates) {
        
        if (this.cellValue ==0 && this.candidates.size() >0  && removeCandidates.containsAll(this.candidates)){
           throw new RequiredFeatureMissingException    ('bad removal: param = '
                     + removeCandidates  + ' this cell C = ' + this.c + ' R = ' 
                     + this.r + ' this value = ' + this.cellValue + ' candidates = '+ this.candidates);
        }      
            
        boolean removed = this.candidates.RemoveAll(removeCandidates);
        if (this.candidates.size() ==1) { 
            integer foundValue=  this.candidates.iterator().next();
            this.cellValue = foundValue;
            system.debug (loggingLevel.warn, 'remove caused candidate size one:  ' 
                          + this.cellValue + '  at R = ' + this.r + ' C = '+ this.c);
            
            system.debug (loggingLevel.warn, 'this.cellValue = ' + this.cellValue + ' found value = ' + foundValue);
            
        }
		return removed;        
    }    
    
    
    public integer cellValue  { 
        public get{
            return cellValue;
        }
        set {
            
            if (value >0 ) { 
                validateValueForCell(value);
                game.removeKnownValueFromCandidates(this);
            }
            
        	cellValue = value;
             
            if (value >0) this.candidates= new set<integer> {};
        }
    }   
     
    public void validateValueForCell(integer v){
        
        if (this.cellValue >0 && v ==0) throw new CalloutException  ('cell already full; value zero');        
        if (this.cellValue >0 && v <> this.cellValue  ) throw new CalloutException  ('cell already full, value inconsistant ');
      
        for (house h : game.getHouses(this)){
			h.validateValueForCell(this, v);
        }
    }
     
    public GameCell(integer c, integer r, gameData game ){
        this.c = c;
        this.r = r;
		this.game = game;

        this.cellValue = 0;
        this.candidates= new set<integer>(GameCell.AllValues); 
          
        this.box = this.calculatebox(this.r, this.c);
  
    }
    
    public integer calculateBox (integer row, integer col) {
           
    	Integer boxRow =  (row-1) / 3;
    	Integer boxCol =  (col-1) / 3;
    
    	Integer boxId = (boxRow * 3) + boxCol + 1;
          
        return boxId;
             
    }    
}