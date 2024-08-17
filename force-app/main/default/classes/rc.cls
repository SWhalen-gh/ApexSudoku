public class rc {           
        integer r;
		integer c;
        public rc (integer r, integer c) {
          //  this.v.add(x);
            //this.v.add(y);
            this.r = r;
            this.c = c;
            
        }
    	public Boolean equals(Object obj) {
        	if (obj instanceof rc) {
            	rc  input = (rc)obj;
           		return ((r==input.r) && (c==input.c));
        	}
        	return false;
    	}
 
    	public Integer hashCode() {
        	return (31 * r) ^ c;
    	} 
         
    }