
/**
 *
 * @author lexie
 */
public class Process {
    
        private int arrive;
        private int priority;
        private int cpu_time;
        private int name;
        private int end;
        private int q_tracker;
        
        public void set_arrive(int x){
            this.arrive = x;
        }
        public void set_priority(int x){
            this.priority = x;
        }
        public void set_cpu_time(int x){
            this.cpu_time = x;
        }
        public void set_name(int x){
            this.name = x;
        }
        public void set_end(int x){
            this.end = x;
        }
        public void set_q_tracker(int x) {
        this.q_tracker = x;
        }
        public int get_arrive(){
            return arrive;
        }
        public int get_priority(){
            return priority;
        }
        public int get_cpu_time(){
            return cpu_time;
        }
        public int get_name(){
            return name;
        }
        public int get_end(){
            return end;
        }
        public int get_q_tracker(){
            return q_tracker;
        }

}
