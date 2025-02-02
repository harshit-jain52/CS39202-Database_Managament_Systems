import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

class QueryInfo {
    String label;
    String query;

    public QueryInfo(String label, String query) {
        this.label = label;
        this.query = query;
    }
}

public class DatabaseQueries {
    private static Properties loadConfig(String filename) throws IOException {
        Properties props = new Properties();
        try (FileInputStream fis = new FileInputStream(filename)) {
            props.load(fis);
        }
        return props;
    }

    private static String buildConnectionString(Properties props) {
        return String.format("jdbc:postgresql://%s:%s/%s",
            props.getProperty("host", "localhost"),
            props.getProperty("port", "5432"),
            props.getProperty("database")
        );
    }

    private static void executeQuery(Connection conn, QueryInfo queryInfo) throws SQLException {
        System.out.println("\n=== " + queryInfo.label + " ===");
        
        try (PreparedStatement stmt = conn.prepareStatement(queryInfo.query);
             ResultSet rs = stmt.executeQuery()) {
            
            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();

            while (rs.next()) {
                StringBuilder row = new StringBuilder();
                for (int i = 1; i <= columnCount; i++) {
                    if (i > 1) row.append("\t");
                    String value = rs.getString(i);
                    row.append(value == null ? "NULL" : value);
                }
                System.out.println(row);
            }
        }
    }

    public static void main(String[] args) {
        if (args.length < 1) {
            System.err.println("Usage: java DatabaseQueries <config_file>");
            System.exit(1);
        }

        List<QueryInfo> queries = new ArrayList<>();
        queries.add(new QueryInfo(
            "Citizens with land area > 1.00",
            "SELECT c.name " +
            "FROM citizens AS c " +
            "JOIN land_records AS l ON c.citizen_id = l.citizen_id " +
            "WHERE l.land_area > 1.00;"
        ));

        queries.add(new QueryInfo(
            "Female students from low-income households",
            "SELECT c1.name " +
            "FROM citizens AS c1 " +
            "JOIN households AS h ON c1.household_id = h.household_id " +
            "WHERE c1.gender = 'Female' " +
            "AND c1.is_student = TRUE " +
            "AND (SELECT SUM(c2.income) " +
            "     FROM citizens AS c2 " +
            "     WHERE c2.household_id = h.household_id) " +
            "< 100000;"
        ));

        queries.add(new QueryInfo(
            "Total rice cultivation area",
            "SELECT SUM(land_area) " +
            "FROM land_records " +
            "WHERE crop_type ILIKE 'rice';"
        ));

        queries.add(new QueryInfo(
            "Young citizens with 10th education",
            "SELECT COUNT(*) " +
            "FROM citizens " +
            "WHERE dob > '2000-01-01' " +
            "AND education ILIKE '10th';"
        ));

        queries.add(new QueryInfo(
            "Panchayat employees with land > 1.00",
            "SELECT c.name " +
            "FROM citizens AS c " +
            "JOIN panchayat_employees AS p ON c.citizen_id = p.citizen_id " +
            "JOIN land_records AS l ON p.citizen_id = l.citizen_id " +
            "WHERE l.land_area > 1.00;"
        ));

        queries.add(new QueryInfo(
            "Household members of Pradhans",
            "SELECT c1.name " +
            "FROM citizens AS c1 " +
            "JOIN households AS h ON h.household_id = c1.household_id " +
            "JOIN citizens AS c2 ON c2.household_id = h.household_id " +
            "JOIN panchayat_employees AS p ON p.citizen_id = c2.citizen_id " +
            "WHERE p.role ILIKE 'Pradhan';"
        ));

        queries.add(new QueryInfo(
            "Street lights in Phulera installed in 2024",
            "SELECT COUNT(*) " +
            "FROM assets " +
            "WHERE type ILIKE 'Street Light' " +
            "AND location ILIKE 'Phulera' " +
            "AND EXTRACT(YEAR FROM installation_date) = 2024;"
        ));

        queries.add(new QueryInfo(
            "Vaccinations in 2024 for children of 10th pass parents",
            "SELECT COUNT(*) " +
            "FROM vaccinations AS v " +
            "JOIN citizens as c1 ON v.citizen_id = c1.citizen_id " +
            "JOIN citizens AS c2 ON c1.parent_id = c2.citizen_id " +
            "WHERE EXTRACT(YEAR FROM v.date_administered) = 2024 " +
            "AND c2.education ILIKE '10th';"
        ));

        queries.add(new QueryInfo(
            "Male births in 2024",
            "SELECT COUNT(*) from citizens " +
            "WHERE gender = 'Male' " +
            "AND EXTRACT(YEAR FROM dob) = 2024;"
        ));

        queries.add(new QueryInfo(
            "Unique citizens in households with panchayat employees",
            "SELECT COUNT(DISTINCT c1.citizen_id) " +
            "FROM citizens AS c1 " +
            "JOIN households AS h ON h.household_id = c1.household_id " +
            "JOIN citizens AS c2 ON c2.household_id = h.household_id " +
            "JOIN panchayat_employees AS p ON p.citizen_id = c2.citizen_id;"
        ));

        try {
            // Load database configuration
            Properties config = loadConfig(args[0]);
            String url = buildConnectionString(config);
            
            // Connect to database and execute queries
            try (Connection conn = DriverManager.getConnection(
                    url,
                    config.getProperty("username"),
                    config.getProperty("password"))) {
                
                for (QueryInfo query : queries) {
                    try {
                        executeQuery(conn, query);
                    } catch (SQLException e) {
                        System.err.println("Error executing query '" + query.label + "': " + e.getMessage());
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading configuration file: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());
        }
    }
}