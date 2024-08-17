public class xy {//similar to a tuple                
        integer x,y;
        public xy (integer x, integer y) {
          //  this.v.add(x);
            //this.v.add(y);
            this.x = x;
            this.y = y;
            
        }
    	public Boolean equals(Object obj) {
        	if (obj instanceof xy) {
            	xy  input = (xy)obj;
           		return ((x==input.x) && (y==input.y));
        	}
        	return false;
    	}
 
    	public Integer hashCode() {
        	return (31 * x) ^ y;
    	} 
         
    }