import java.util.Arrays;
import java.util.Scanner;
/**
 * This program lets a user decide whether to multiply two matrices or find the transpose of a matrix.
 * The dimesions and contents of the matrices are decided by the user.
 * 
 * @ 1/10/2025
 */
public class MM
{
    public static void main(String[] args)
    {
        MM Matrix = new MM();
        Scanner kb = new Scanner(System.in);
        char cont = 'N';
        do{
            System.out.println("Would you like to multiply or transpose? (M/T)");
            char resp = '0';
            // The user decides which operation to perform.
            do {
               resp = kb.nextLine().charAt(0); 
            }while(resp!='m'&& resp!='M' && resp!='t' && resp!='T');
            if ((resp == 'm')||(resp == 'M')){ // Perform multiplication
                // Initialize and display Matrix 1
                double A[][] = Matrix.init_matrix();
                System.out.println(); System.out.println("Matrix 1: ");
                Matrix.Print_Matrix(A);
        
                // Initialize and display Matrix 2
                double B[][] = Matrix.init_matrix();
                System.out.println(); System.out.println("Matrix 2: ");
                Matrix.Print_Matrix(B);
        
                // Multiply matrices and display answer
                double Ans[][] = Matrix.Multiply(A,B);
                System.out.println(); System.out.println("Answer is: ");
                Matrix.Print_Matrix(Ans);
            }else{ // Find transpose
                // Initialize and display Matrix
                double A[][] = Matrix.init_matrix();
                System.out.println(); System.out.println("Original Matrix: ");
                Matrix.Print_Matrix(A);
            
                double Ans[][] = Matrix.Transpose(A);
                System.out.println(); System.out.println("Transposed Matrix: ");
                Matrix.Print_Matrix(Ans);
            }
            System.out.println("Would you like to do another? (Y/N)");
            cont = kb.nextLine().charAt(0);
        }while(cont=='Y'||cont=='y');
    }
    private double[][] init_matrix(){
        // The user the rows and columns of the matrix
        Scanner kb = new Scanner(System.in);
        System.out.println("Enter number of rows: ");
        int rows = kb.nextInt();
        System.out.println("Enter number of columns: ");
        int columns = kb.nextInt();
        double X[][] = new double[rows][columns];
        
        // The user inputs the entries of the matrix
        for (int p=0; p<X.length; p++){ 
             for (int z=0; z<X[0].length; z++){
                System.out.println("Enter a number for [" + p + "]" + " [" + z + "]: ");
                X[p][z] = kb.nextDouble();
            }
        }
        return X;
    }
    private double[][] Multiply(double[][] A, double[][] B){
        // If the # of rows of Matrix 1 does not match the # of columns of Matrix 2, stop the program
        if (A[0].length != B.length){
                throw new ArithmeticException("Error: Cannot multiply matrices of these dimensions.");
        }else{
            double C[][] = new double[A.length][B[0].length];  
            // Matrix Multiplication
            for (int z=0; z<C.length; z++){
               for (int m=0; m<B[0].length; m++){ // multiply A and B
                    for (int n=0; n<A[0].length; n++){// C = A * B
                       C[z][m] = C[z][m] + (A[z][n] * B[n][m]);
                    }
                }
            }
            return C;
        }
    }
    private void Print_Matrix(double[][] C){
        // Print the passed in matrix to the console
        for (int p=0; p<C.length; p++){ 
             for (int z=0; z<C[0].length; z++){
                System.out.print(C[p][z] + " ");    
             }
             System.out.println();
        }
    }
    private double[][] Transpose(double[][] A){
        double T[][] = new double[A[0].length][A.length];
        // Create the transpose of matrix A
        for (int i=0; i<T.length; i++){ 
            for (int j=0; j<T[0].length; j++){
                T[i][j] = A[j][i];
            }
        }
        return T;
    }
}


