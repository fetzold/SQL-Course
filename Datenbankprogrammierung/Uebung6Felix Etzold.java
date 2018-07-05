package uebung6;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * @author Felix
 */
public class Uebung6
{
    public static void main(String[] args) throws SQLException, IOException
    {
        Connection con = DriverManager.getConnection
        (
            "jdbc:db2:///*IP*/geodb", 									
            /*Instanz*/, 
            "******"																// Bitte Passwort eingeben
        );

        System.out.println("Stadt?");
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        String ort = in.readLine();

        /***********************************************************************
        **
        ** Aufgabe 1.1 (a)
        **
        ***********************************************************************/

        System.out.println("\n--Aufgabe 1.1(a)");
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery("SELECT geo_landkreis FROM geodb WHERE geo_ort = '" + ort + "'");
        
        while(rs.next())
        {
            System.out.println(rs.getString(1));
        }
        rs.close();

        st.close();

        /***********************************************************************
        **
        ** Aufgabe 1.1 (b)
        **
        ***********************************************************************/

        System.out.println("\n--Aufgabe 1.1(b)");
        PreparedStatement pst = con.prepareStatement("SELECT geo_landkreis FROM geodb WHERE geo_ort = ?");  
        pst.setString(1, ort);
        rs = pst.executeQuery();
        
        while(rs.next())
        {
            System.out.println(rs.getString(1));
        }
        rs.close();
        
        pst.close();

        /***********************************************************************
        **
        ** Aufgabe 1.2
        **
        ***********************************************************************/

        System.out.println("\n--Aufgabe 1.2");
        pst = con.prepareStatement("SELECT count(*) FROM geodb WHERE geo_landkreis = ?");
        pst.setString(1, "Kreisfreie Stadt " + ort);

        rs = pst.executeQuery();
        
        boolean isKreisfrei = false; 
        if(rs.next())
        {
            isKreisfrei = rs.getInt(1) > 0; 
        }
            
        if(isKreisfrei)                                        
        {
            // Ortsteile ermitteln
            pst = con.prepareStatement("SELECT geo_ortsteil FROM geodb WHERE geo_ort = ?"); 
            pst.setString(1, ort);
            rs = pst.executeQuery();
            
            while(rs.next())
            {
                if(rs.getString(1) == null)
                {
                    System.out.println("<unbekannt>");
                    break;
                }
                System.out.println(rs.getString(1));
            }
            rs.close();
            
            pst.close();
        }
        else   
        {
            // Ermittle für Landkreise alle Städte
            pst = con.prepareStatement("SELECT geo_landkreis FROM geodb WHERE geo_ort = ?"); 
            pst.setString(1, ort);
            rs = pst.executeQuery();

            while(rs.next())
            {
                String landkreis = rs.getString(1);                             // Landkreis

                System.out.println("***" + landkreis);

                //Städte aus Landkreis
                PreparedStatement pstatement2 = con.prepareStatement("SELECT geo_ort FROM geodb WHERE geo_landkreis = ?");
                pstatement2.setString(1, landkreis);

                ResultSet rs2 = pstatement2.executeQuery();
                
                while(rs2.next())
                {
                    System.out.println(rs2.getString(1));
                }
                rs2.close();
            }
            rs.close();
            
            pst.close();
        }
        con.close();
        /***********************************************************************
        **
        ** Aufgabe 2.1 (a)
        **
        ***********************************************************************/
        
        System.out.println("\n--Aufgabe 2.1");
        con = DriverManager.getConnection
        (
             "jdbc:db2:///*IP*/tpch", 									
            /*Instanz*/, 
            "******"																				//Bitte Passwort eingeben
        );
        DatabaseMetaData meta = con.getMetaData();
        System.out.println("getDatabaseMajorVersion: " + meta.getDatabaseMajorVersion());
        System.out.println("getDatabaseMinorVersion: " + meta.getDatabaseMinorVersion());
        System.out.println("getDatabaseProductName: " + meta.getDatabaseProductName());
        System.out.println("getDatabaseProductVersion: " + meta.getDatabaseProductVersion());
        System.out.println("getDriverMajorVersion: " + meta.getDriverMajorVersion());
        System.out.println("getDriverMinorVersion: " + meta.getDriverMinorVersion());
        System.out.println("getDriverName: " + meta.getDriverName());
        System.out.println("getDriverVersion: " + meta.getDriverVersion());

        /***********************************************************************
        **
        ** Aufgabe 2.2 (a)
        **
        ***********************************************************************/

        System.out.println("\n--Aufgabe 2.2");
        System.out.println("Die folgenden Tabellen sind definiert: ");
        ResultSet tableRs = meta.getTables(null, "DB2INS28", null, null);

        while(tableRs.next()) 
        {
            String tableName = tableRs.getString(3);
            System.out.println(tableName);
        }

        tableRs.close();

        /***********************************************************************
        **
        ** Aufgabe 2.3 (a)
        **
        ***********************************************************************/

        System.out.println("\n--Aufgabe 2.3");
        //Städte aus Landkreis
        st = con.createStatement();
        rs = st.executeQuery("SELECT R_REGIONKEY, TRIM(R_NAME) AS R_NAME FROM REGION");

        print(rs, 3);

        st.close();

        // Verbindung schließen
        con.close();
    }
  
    private static void print(ResultSet rs, int k) throws SQLException
    {
        ResultSetMetaData rsmd = rs.getMetaData();
        int numColumns = rsmd.getColumnCount();

        System.out.println("Attribute: ");
        System.out.print("(");
        for(int cols = 1; cols <= numColumns; cols++)
        {
            System.out.print(rsmd.getColumnName(cols));
            
            if(cols < numColumns)
            {
                System.out.print(", ");
            }
        }
        System.out.print(")\n");

        while(rs.next() && k > 0)
        {
            System.out.print("(");
            for(int cols = 1; cols <= numColumns; cols++)
            {
                if (rsmd.getColumnType(cols) == java.sql.Types.VARCHAR || rsmd.getColumnType(cols) == java.sql.Types.CHAR)
                {
                    System.out.print(rs.getString(cols));
                }
                
                if (rsmd.getColumnType(cols) == java.sql.Types.INTEGER)
                {
                    System.out.print(rs.getInt(cols));
                }

                if(cols < numColumns)
                {
                    System.out.print(", ");
                }
            }
            System.out.print(")\n");
            
            k--;
        }

        rs.close();
    }
}
