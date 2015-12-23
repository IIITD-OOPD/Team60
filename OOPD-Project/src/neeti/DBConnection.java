package neeti;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBConnection implements DBHelper {
		private String user;
		private String pwd;
		private String dbname;
		private String url;
		private Connection con;

		public DBConnection(String driver, String url, String dbName, String user, String pwd)
		{
			this.url = url;
			dbname = dbName;
			this.user = user;
			this.pwd = pwd;
			try {
				Class.forName(driver);
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
		}

		
		@Override
		public Connection getConnection() throws Exception {
			try {
				
				con = DriverManager.getConnection(url+dbname, user, pwd);
			} catch (SQLException e) {
				e.printStackTrace();
				throw new Exception("Error 1000 has occured");
			}
			return con;
		}
		
		public void executeDDLOrDML(String sql, int errorCode) throws Exception {
			try {
				Statement stmt = con.createStatement();
				stmt.executeUpdate(sql);
				stmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
				throw new Exception("error occured, code : " + errorCode);
			}

		}

		
		@Override
		public void destroyDatabase() {
			try {
				Connection con = getConnection();
				Statement stmt = con.createStatement();
				stmt.executeUpdate(" DROP database " + dbname);
			} catch (SQLException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}

		}

		@Override
		public String createDatabase() throws Exception {
			Connection con = null;
			try {
				con = DriverManager.getConnection(url, user, pwd);
				Statement stmt = con.createStatement();
				stmt.execute("drop database if exists " + dbname);
				stmt = con.createStatement();
				stmt.execute(" Create database " + dbname);
				
			} catch (SQLException e) {
				e.printStackTrace();
				throw new Exception("Error 1001 has occured");
			}finally {
				try {
					con.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			return dbname;
		}

		@Override
		public String getDBName() {
			return dbname;
		}

		@Override
		public void createTable(String ddl) throws Exception {
			try {
				Connection con = getConnection();
				Statement stmt = con.createStatement();
				stmt.executeUpdate(ddl);
				stmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
				throw new Exception("Error 1002 has occured");
			}
			
		}

		@Override
		public boolean isTableCreated(String table) throws Exception {
			Connection con2 = null;
			try {
				con2 = DriverManager.getConnection(url, user, pwd);
				String sql = "SHOW TABLES FROM " + dbname + " LIKE '%" + table + "'";
				return checkBooleanQuery(sql, con2);
			} catch (SQLException e) {
				e.printStackTrace();
				throw new Exception("Error 1018 has occured");
			}finally{
				try {
					con2.close();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			
		}

		@Override
		public boolean checkBooleanQuery(String query) throws Exception {
			return checkBooleanQuery(query, con);	
		}
		
		private boolean checkBooleanQuery(String query, Connection newCon) throws Exception {
			try {
				Statement stmt = newCon.createStatement();
				ResultSet rs = stmt.executeQuery(query);
				boolean next = rs.next();
				rs.close();
				return next;
			} catch (SQLException e) {
				e.printStackTrace();
				throw new Exception("Error 1002 has occured");
			}
			
		}

		@Override
		public boolean isDBCreated() throws Exception {
			Connection con2 = null;
			try {
				con2 = DriverManager.getConnection(url, user, pwd);
				String sql = "SHOW DATABASES LIKE '%" + dbname + "%'";
				return checkBooleanQuery(sql, con2);
			} catch (SQLException e) {
				e.printStackTrace();
				throw new Exception("Error 1018 has occured");
			}finally{
				try {
					con2.close();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}

		@Override
		public void releaseResources() {
			try {
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	


}
