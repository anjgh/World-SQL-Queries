
import java.sql.*;
public class Assignment2 {
	// A connection to the database
		Connection connection;

		// Statement to run queries
		Statement sql;

		// Prepared Statement
		PreparedStatement ps;

		// Resultset for the query
		ResultSet rs;

		// CONSTRUCTOR
		Assignment2() {
			System.out.println("-------- PostgreSQL JDBC Connection Testing -----------");
			try {
				// Load JDBC driver
				Class.forName("org.postgresql.Driver");
			} catch (ClassNotFoundException e) {
				System.out.println("Where is your PostgreSQL JDBC Driver? Include in your library path!");
				e.printStackTrace();
				return;
			}
			System.out.println("PostgreSQL JDBC Driver Registered!");
		}

		// Using the input parameters, establish a connection to be used for this
		// session. Returns true if connection is sucessful
		public boolean connectDB(String URL, String username, String password) throws SQLException {
			try {
				// Make the connection to the database, <username>
				System.out.println("URL:" + URL);
				System.out.println("username:" + username);
				System.out.println("password:" + password);
				System.out.println("done");
				connection = DriverManager.getConnection(URL, username, password);
			} catch (SQLException e) {
				System.out.println("Connection Failed");
				e.printStackTrace();
				return false;
			}
			if (connection != null) {
				
				sql = connection.createStatement();
				return true;
			} else {
				System.out.println("connection Failed");
				return false;
			}
		}

		// Closes the connection. Returns true if closure was sucessful
		public boolean disconnectDB() throws SQLException {
			try {
				connection.close();
			} catch (SQLException e) {
				System.out.println("Execution Failed");
				e.printStackTrace();
				return false;
			}
			return true;
		}

		public boolean insertCountry(int cid, String name, int height, int population) throws SQLException {
			int output;
			String sqlText;
			sqlText = "INSERT INTO country " + "VALUES (" + String.valueOf(cid) + "," + name + "," + String.valueOf(height)
					+ "," + String.valueOf(population) + ")";
			try {
				output = sql.executeUpdate(sqlText);
			} catch (SQLException e) {
				System.out.println("");
				e.printStackTrace();
				return false;
			}
			return true;
		}

		public int getCountriesNextToOceanCount(int oid) {
			int output;
			String sqlText;
			sqlText = "SELECT count(cid) AS total_cid " + "From oceanAccess " + "WHERE oid =" + String.valueOf(oid);
			try {
				rs = sql.executeQuery(sqlText);
			} catch (SQLException e) {
				System.out.println("Execution Failed");
				e.printStackTrace();
				return -1;
			}
			if (rs != null) {
				try {
					output = rs.getInt("total_cid");
				} catch (SQLException e) {
					System.out.println("");
					e.printStackTrace();
					return -1;
				}
				return output;
			}
			return -1;
		}

		public String getOceanInfo(int oid) {
			String output;
			String sqlText;
			sqlText = "SELECT * " + "From ocean " + "Where oid =" + String.valueOf(oid);
			try {
				rs = sql.executeQuery(sqlText);
			} catch (SQLException e) {
				System.out.println("Execution Failed");
				e.printStackTrace();
				return "";
			}
			if (rs != null) {
				try {
					output = String.valueOf(rs.getInt("oid")) + ":" + rs.getString("oname") + ":"
							+ String.valueOf(rs.getInt("depth"));
				} catch (SQLException e) {
					System.out.println("");
					e.printStackTrace();
					return "";
				}
				return output;
			}
			return "";
		}

		public boolean chgHDI(int cid, int year, float newHDI) {
			int output;
			String sqlText;
			sqlText = "UPDATE hdi " + "SET hdi_score = " + String.valueOf(newHDI) + " WHERE year = " + String.valueOf(year)
					+ " AND cid = " + String.valueOf(cid);
			try {
				output = sql.executeUpdate(sqlText);
			} catch (SQLException e) {
				System.out.println("");
				e.printStackTrace();
				return false;
			}
			return true;
		}

		public boolean deleteNeighbour(int c1id, int c2id) {
			int output;
			int output2;
			String sqlText;
			String sqlText1 = "DELETE FROM neighbour " + " WHERE country = " + String.valueOf(c1id) + " AND neighbor = "
					+ String.valueOf(c2id);
			String sqlText2 = "DELETE FROM neighbour " + " WHERE country = " + String.valueOf(c2id) + " AND neighbor = "
					+ String.valueOf(c1id);
			try {
				output = sql.executeUpdate(sqlText1);
				output2 = sql.executeUpdate(sqlText2);
			} catch (SQLException e) {
				System.out.println("");
				e.printStackTrace();
				return false;
			}
			return true;
		}

		public String listCountryLanguages(int cid) throws SQLException {
			String output = "";
			String sqlText;
			int n = 1;
			sqlText = "SELECT lid, lname, (population*lpercentage/100) AS population " + "From language, country "
					+ "Where country.cid = language.cid AND language.cid = " + String.valueOf(cid);
			try {
				rs = sql.executeQuery(sqlText);
			} catch (SQLException e) {
				System.out.println("Execution Failed");
				e.printStackTrace();
				return "";
			}
			if (rs.next()) {
				try {
					output = output + "l" + n + String.valueOf(rs.getInt("lid")) + ":" + "l" + n + rs.getString("lname")
							+ ":" + "l" + n + String.valueOf(rs.getInt("population")) + "#";
					n = n + 1;
				} catch (SQLException e) {
					System.out.println("");
					e.printStackTrace();
					return "";
				}
			}

			return output;
		}

		public boolean updateHeight(int cid, int decrH) {
			int output;
			String sqlText;
			sqlText = "UPDATE country " + "SET height = height - " + String.valueOf(decrH) + " WHERE cid = "
					+ String.valueOf(cid);
			try {
				output = sql.executeUpdate(sqlText);
			} catch (SQLException e) {
				System.out.println("");
				e.printStackTrace();
				return false;
			}
			return true;
		}

		public boolean updateDB() {
			int output;
			String sqlText;
			sqlText = "CREATE TABLE mostPopulousCountries(" + "cid INTEGER," + "cname   VARCHAR(20)" + ")";
			try {
				output = sql.executeUpdate(sqlText);
			} catch (SQLException e) {
				System.out.println("");
				e.printStackTrace();
				return false;
			}
			sqlText = "INSERT INTO mostPopulousCountries(" + "SELECT cid, cname " + "FROM country "
					+ "WHERE population >= 100000000 " + "ORDER BY cid ASC " + ")";
			try {
				output = sql.executeUpdate(sqlText);
			} catch (SQLException e) {
				System.out.println("");
				e.printStackTrace();
				return false;
			}

			return true;
		}
}
