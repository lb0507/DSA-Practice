
import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

/**
 *
 * @author Lexie Bardwell
 *  COSC 4327-01
 *  Assignment #2 Scheduling Program
 */
public class SchedulingSim {
     public static void main(String[] args) throws FileNotFoundException{
         
        int quantum = 2; 
        int num_of_processes = 0;
        double turnover = 0;
        double total_turnover = 0;
        double avg_turnover = 0;
        int burst_time;
        int total_time = 0;
        int time = 0;
        int j = 0;
        int run_l = 0; //run_l points to the slot after the last element in Running queue
        int rdy_l = 0; //rdy_l points to the slot after the last element in Ready queue
        boolean current_done = false;
        boolean new_arrival = false;
        
        File file = new File("src/main/processes.txt");
        
        Scanner sc = new Scanner(file);
        Scanner kb = new Scanner(System.in);
        num_of_processes = sc.nextInt(); //read first line
        Process [] Processes = new Process[num_of_processes]; //declare array to hold processes
        int i = 0;
        while (sc.hasNextLine()){ // read through file
                                    // create new process in each slot of array  
            Processes[i] = new Process();
            Processes[i].set_arrive(sc.nextInt());
            Processes[i].set_priority(sc.nextInt());
            burst_time = sc.nextInt();
            Processes[i].set_cpu_time(burst_time);
            Processes[i].set_name(i);
            total_time = total_time + burst_time;  //total time will be used for loop range
            i++;
        }
        Process [] Running = new Process[total_time]; // Simulates CPU
        Process [] Ready = new Process[num_of_processes];   // Ready queue
        
        System.out.println("Input a quantum: "); //define quantum for RR
        quantum = kb.nextInt();

        while (time < total_time){
            System.out.println();
            System.out.println("Time = " + time);
            // deploying arrivals
            for (int k = 0; k < Processes.length; k++) { //look through processes to find if one needs to be deployed
                if (time == Processes[k].get_arrive()){
                    System.out.println("Process " + Processes[k].get_name() + " arrived.");
                    
                    if (time == 0){ 
                    //first slot in queue is empty, put in queue
                        Running[time] = Processes[k];
                        new_arrival = true;     
                    }else{ // Current time slot in running queue is occupied
                        if (Running[time-1].get_priority() > Processes[k].get_priority()){ 
                            if (current_done == false){
                                //priority is greater than what is currently in queue
                                //send the running process to ready queue
                                j = rdy_l - 1;
                                if (rdy_l == 0){ //if ready queue is empty
                                    Ready[rdy_l] = Running[time-1];
                                }else{ //find spot in ready queue based on priority and then q_tracker
                                    while ((j>=0)&&(Ready[j].get_priority() >= Running[time-1].get_priority())){ //error here
                                        Ready[j+1] = Ready[j];
                                        j--;       
                                    }
                                    if (j < 0){
                                        j = 0;
                                    }
                                    if ((j==0)&&(Ready[j].get_priority() >= Running[time-1].get_priority())){  //first
                                        Ready[j] = Running[time-1];
                                    }else{  //interior or last
                                        Ready[j+1] = Running[time-1];
                                    }
                                }
                            } System.out.println("Preempting process " + Running[time-1].get_name() + ".");
                            // and deploy new process
                            Running[time] = Processes[k];
                            System.out.println("Dispatching process " + Running[time].get_name() + ".");
                            new_arrival = true;
                        }else{ //put in ready queue
                            j = rdy_l - 1;
                            if (rdy_l == 0){ //if ready queue is empty
                                Ready[rdy_l] = Processes[k];
                            }else{ //find spot in ready queue based on priority
                                  //move contents down
                                while ((j>=0)&&(Ready[j].get_priority() > Processes[k].get_priority())){
                                        Ready[j+1] = Ready[j];
                                        j--;       
                                }
                                if (j<0){ //for first case
                                        j=0;
                                }
                                if ((j==0)&&(Ready[j].get_priority() > Processes[k].get_priority())){  //first
                                        Ready[j] = Processes[k];
                                }else{  //interior or last
                                    Ready[j+1] = Processes[k];
                                } 
                            }
                        new_arrival = false;
                       } 
                        rdy_l++; //update pointer to the last element in Ready queue
                    }                   
                    break;
                } 
            }   
            if (current_done == true){ //the process running in the queue has a CPU_time of 0, switch to next process
                Running[time] = Ready[0]; //deploy the next process waiting in the ready queue
                System.out.println("Dispatching process " + Running[time].get_name() + ".");
                for(int n =0; n < (rdy_l)-1; n++){
                    //move the rest of the proceses up in line
                    Ready[n] = Ready[n+1];  
                }
                rdy_l--; //move back the pointer to the last element
                Ready[rdy_l] = null; //delete duplicate from Ready queue
                current_done = false;
            }else{
                if ((Ready[0] != null) && (Running[time-1].get_priority() == Ready[0].get_priority()) 
                   && (Running[time-1].get_q_tracker() >= quantum) && (new_arrival == false) && (Running[time-1].get_name() != Ready[0].get_name())){
                    //multiple processes of the same priority, follow round robin procedue
                    //swap processes
                    Running[time] = Ready[0];
                    j=0;
                    if (Ready[j+1] != null){                      
                        while(Ready[j].get_priority()==Ready[j+1].get_priority()){ //handles cases of more than two same priorities
                            Ready[j] = Ready[j+1];
                            j++;
                            if (Ready[j+1]== null){
                                break;
                            }
                        }
                    }
                    Ready[j] = Running[time-1];
                    Running[time-1].set_q_tracker(0); //reset q_tracker for the process sent to Ready queue
                    System.out.println("Quantum completed; dispatching process " + Running[time].get_name() + ".");
                }else if (new_arrival == false) {//continue running the current process
                    Running[time] = Running[time-1];    
                }
            }
            Running[time].set_cpu_time((Running[time].get_cpu_time())-1);
            if (Running[time].get_cpu_time() == 0){
                Running[time].set_end(time+1); //store the time of process completion for turnover time calculations
                // the time+1 accounts for how time is incremented lastly in the loop
                current_done = true;
                System.out.println("Process " + Running[time].get_name() + " has completed."); 
            }
            new_arrival = false;
            run_l++; 
            Running[time].set_q_tracker(Running[time].get_q_tracker()+1); //increment q_tracker for the current process
            if (current_done == false){
                System.out.println("Running process " + Running[time].get_name() + "."); 
            }
            time++;           
            
            //Print out Ready queue
            int k = 0;   
            System.out.print("Ready Queue: ");
                while (Ready[k] != null){//(k != rdy_l){
                System.out.print(Ready[k].get_name() + " ");      
                k++;  
            }
            System.out.println();
        }
        //calculate and print turnover times
        System.out.println();
        System.out.println("End time = " + time);
        for (Process P : Processes) {
             turnover = P.get_end() - P.get_arrive();
             total_turnover = total_turnover + turnover;
             System.out.println("Turnover time for process " + P.get_name() + ": " + turnover);
        }
        avg_turnover = total_turnover / num_of_processes;
        System.out.println("Average time for processes : " + avg_turnover); 
    }
}


