using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using IBM.Data.DB2;


namespace Uebung8
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                DB2Connection con = new DB2Connection("Server = /*IP*/; UID=/*Instanz*/; PWD=*****; DATABASE=TPCH");
                con.Open();
                Console.Write("Land (in Großbuchstaben angeben) ? ");
                String input = "";
                while (input.Length == 0 || input == null)
                {
                    input = Console.In.ReadLine();
                }
                Console.WriteLine();

                /***********************************************************************
                **
                ** Aufgabe 1.1 (a)
                **
                ***********************************************************************/
                Console.WriteLine("***************");
                Console.WriteLine("Aufgabe 1.1 (a)");
                Console.WriteLine("***************");
                Console.WriteLine();

                DB2Command cmd = con.CreateCommand();
                cmd.CommandText = "SELECT c_name FROM customer, nation WHERE n_nationkey = c_nationkey AND n_name = '"+ input +"' ";
                DB2DataReader reader1 = cmd.ExecuteReader();
                
                while (reader1.Read())
                {
                    Console.WriteLine("Kunde: " + reader1.GetString(0));
                }
                reader1.Close();

                Console.WriteLine();
                Console.WriteLine();


                /***********************************************************************
                **
                ** Aufgabe 1.1 (b)
                **
                ***********************************************************************/
                Console.WriteLine("***************");
                Console.WriteLine("Aufgabe 1.1 (b)");
                Console.WriteLine("***************");
                Console.WriteLine();

                cmd.CommandText = "SELECT c_name FROM customer, nation WHERE n_nationkey = c_nationkey AND n_name = ? ";
                cmd.Prepare();
                cmd.Parameters.Add("n_name", DB2Type.VarChar, 25);
                cmd.Parameters["n_name"].Value = input;
                DB2DataReader reader2 = cmd.ExecuteReader();

                while (reader2.Read())
                {
                    Console.WriteLine("Kunde: " + reader2.GetString(0));
                }
                reader2.Close();

                Console.WriteLine();
                Console.WriteLine();

                
                /***********************************************************************
                **
                ** Aufgabe 1.2
                **
                ***********************************************************************/
                Console.WriteLine("***********");
                Console.WriteLine("Aufgabe 1.2");
                Console.WriteLine("***********");
                Console.WriteLine();

                cmd.CommandText = "SELECT c_name, c_custkey, COUNT(o_totalprice) FROM customer, nation, orders WHERE n_nationkey = c_nationkey AND c_custkey = o_custkey AND n_name = '" + input + "' GROUP BY c_name, c_custkey";

                DB2DataReader reader3 = cmd.ExecuteReader();

                while (reader3.Read())
                {

                    DB2Command SPCMD = con.CreateCommand();
                    SPCMD.CommandText = "orders_of";                    //Geb ich den namen der SP an
                    SPCMD.CommandType = CommandType.StoredProcedure;    //Man muss noch zeigen das es SP ist
                    SPCMD.Parameters.Add("IN_table", DB2Type.Integer).Value = reader3.GetDB2Int32(1);
                    SPCMD.Parameters.Add("OUT_sql", DB2Type.Integer).Direction = ParameterDirection.Output;
                    DB2DataReader dr = SPCMD.ExecuteReader();
                    Console.WriteLine("Kunde:               " + reader3.GetString(0));
                    Console.WriteLine("Kundenr.:            " + reader3.GetString(1));
                    Console.WriteLine("AnzahlBestellungen:  " + SPCMD.Parameters["OUT_sql"].Value);

                    decimal summe = 0;
                    bool first = true; 
                    int days = 0; 

                    while(dr.Read())
                    {   
                        summe += Convert.ToDecimal(dr["TOTALPRICE"]);
                    }
                    Console.WriteLine("Gesamtumsatz:        " + summe + " $ (USD)");
                    dr.Close();
                }
                reader1.Close();
				
                Console.WriteLine();
                Console.WriteLine();

                /***********************************************************************
                **
                ** Aufgabe 2.1 
                **
                ***********************************************************************/
                Console.WriteLine("***********");
                Console.WriteLine("Aufgabe 2.1");
                Console.WriteLine("***********");
                Console.WriteLine();

                Console.WriteLine("ServerType:    " + con.ServerType);                                              //Typ des Servers
                Console.WriteLine("ServerVersion: " + con.ServerVersion);                                           //Version des Servers 
                Console.WriteLine("Version:       " + con.ServerMajorVersion + "." + con.ServerMinorVersion);       //übergeordnete Version und untergeordnete Version des Servers 
                Console.WriteLine("Verbindung:    " + con.ConnectionString);                                        //Ruft die Zeichenfolge ab, die zum Öffnen einer Datenbankverbindung verwendet wird
                Console.WriteLine("Datenbankname: " + con.Database);                                                //Ruft den Namen der aktuellen Datenbank ab
                Console.WriteLine("InProperty1:   " + con.InternalProperty1);
                Console.WriteLine("InProperty7:   " + con.InternalProperty7);
                Console.WriteLine("BuildVersion:  " + con.ServerBuildVersion);                                      //Buildversion des Servers
                Console.WriteLine("RevVersion:    " + con.ServerRevisionVersion);                                   //Überarbeitungsversion des Servers
                Console.WriteLine("Status:        " + con.State);                                                   //aktueller Status der Verbindung
                Console.WriteLine("UserId:        " + con.UserId);                                                  //UserId

                Console.WriteLine();
                Console.WriteLine();

                /***********************************************************************
                **
                ** Aufgabe 2.2
                **
                ***********************************************************************/
                Console.WriteLine("***********");
                Console.WriteLine("Aufgabe 2.2");
                Console.WriteLine("***********");
                Console.WriteLine();

                cmd.CommandText = "SELECT n_nationkey, n_name, n_regionkey FROM nation";
                DB2DataReader reader5 = cmd.ExecuteReader();
                printResult(reader5, 3);
                reader5.Close();

                Console.WriteLine();
                Console.WriteLine();
                /***********************************************************************
                **
                ** Aufgabe 3
                **
                ***********************************************************************/
                Console.WriteLine("***********");
                Console.WriteLine("Aufgabe 3");
                Console.WriteLine("***********");
                Console.WriteLine();
                
                DataSet ds = new DataSet();
                DB2DataAdapter da = new DB2DataAdapter("SELECT o_orderkey, o_custkey, o_orderpriority, o_totalprice FROM orders", con);         //benötigt zum Füllen des ds
                DB2CommandBuilder cb = new DB2CommandBuilder(da);

                Console.Write("Kundennummer(o_custkey) eingeben: ");
                String input2 = "";
                while (input2.Length == 0 || input == null)
                {
                    input2 = Console.In.ReadLine();
                }
                Console.WriteLine();
                con.Close();

                Console.WriteLine();
                Console.WriteLine();
                Console.ReadKey();
            }
            catch (DB2Exception e)
            {
                Console.Error.WriteLine(e.Message);
                Console.ReadKey();
            }
        }
        static void printResult(DB2DataReader reader5, int k)
        {

        }
    }
}

