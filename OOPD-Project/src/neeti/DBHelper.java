package neeti;

import java.sql.Connection;

public interface DBHelper {
	

		String createDatabase() throws Exception;

		boolean isTableCreated(String table) throws Exception;

		boolean isDBCreated() throws Exception;

		String getDBName();

		void createTable(String ddl) throws Exception;

		void destroyDatabase();

		Connection getConnection() throws Exception;
		
		void executeDDLOrDML(String sql, int errorCode) throws Exception;

		public abstract boolean checkBooleanQuery(String query) throws Exception;

		void releaseResources();	

}
