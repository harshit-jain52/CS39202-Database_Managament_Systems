#include <sql.h>
#include <sqlext.h>
#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>
#include <cstring>

// Function to read connection string from config file
std::string readConnectionString(const std::string& filename) {
    std::ifstream file(filename);
    if (!file.is_open()) {
        throw std::runtime_error("Unable to open config file: " + filename);
    }

    std::stringstream buffer;
    std::string line;
    std::string connStr;

    // Read file and construct connection string
    while (std::getline(file, line)) {
        // Skip empty lines and comments
        if (line.empty() || line[0] == '#') {
            continue;
        }

        size_t pos = line.find('=');
        if (pos != std::string::npos) {
            std::string key = line.substr(0, pos);
            std::string value = line.substr(pos + 1);

            // Trim whitespace
            key.erase(0, key.find_first_not_of(" \t"));
            key.erase(key.find_last_not_of(" \t") + 1);
            value.erase(0, value.find_first_not_of(" \t"));
            value.erase(value.find_last_not_of(" \t") + 1);

            buffer << key << "=" << value << ";";
        }
    }

    return buffer.str();
}

struct QueryInfo {
    std::string label;
    std::string query;
};

class DatabaseConnection {
private:
    SQLHENV env;
    SQLHDBC dbc;
    SQLHSTMT stmt;
    
    void checkError(SQLHANDLE handle, SQLSMALLINT type, RETCODE ret) {
        if (ret == SQL_SUCCESS || ret == SQL_SUCCESS_WITH_INFO)
            return;

        SQLSMALLINT i = 0;
        SQLINTEGER native;
        SQLCHAR state[7];
        SQLCHAR text[256];
        SQLSMALLINT len;
        
        while (SQLGetDiagRec(type, handle, ++i, state, &native, text,
                            sizeof(text), &len) == SQL_SUCCESS) {
            std::cerr << "ODBC Error: " << text << std::endl;
        }
    }

public:
    DatabaseConnection() : env(NULL), dbc(NULL), stmt(NULL) {}

    bool connect(const std::string& connStr) {
        // Allocate environment handle
        if (SQL_SUCCESS != SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, &env)) {
            std::cerr << "Failed to allocate environment handle\n";
            return false;
        }

        // Set ODBC version
        if (SQL_SUCCESS != SQLSetEnvAttr(env, SQL_ATTR_ODBC_VERSION, (void*)SQL_OV_ODBC3, 0)) {
            std::cerr << "Failed to set ODBC version\n";
            return false;
        }

        // Allocate connection handle
        if (SQL_SUCCESS != SQLAllocHandle(SQL_HANDLE_DBC, env, &dbc)) {
            std::cerr << "Failed to allocate connection handle\n";
            return false;
        }

        // Set connection timeout
        SQLSetConnectAttr(dbc, SQL_ATTR_CONNECTION_TIMEOUT, (SQLPOINTER)5, 0);

        // Connect to database
        SQLCHAR outstr[1024];
        SQLSMALLINT outstrlen;
        RETCODE ret = SQLDriverConnect(dbc, NULL, 
                                     (SQLCHAR*)connStr.c_str(), SQL_NTS,
                                     outstr, sizeof(outstr),
                                     &outstrlen, SQL_DRIVER_NOPROMPT);

        if (SQL_SUCCESS != ret && SQL_SUCCESS_WITH_INFO != ret) {
            checkError(dbc, SQL_HANDLE_DBC, ret);
            return false;
        }

        // Allocate statement handle
        if (SQL_SUCCESS != SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt)) {
            std::cerr << "Failed to allocate statement handle\n";
            return false;
        }

        return true;
    }

    void executeQuery(const QueryInfo& queryInfo) {
        std::cout << "\n=== " << queryInfo.label << " ===\n";
        
        RETCODE ret = SQLExecDirect(stmt, (SQLCHAR*)queryInfo.query.c_str(), SQL_NTS);
        if (SQL_SUCCESS != ret && SQL_SUCCESS_WITH_INFO != ret) {
            checkError(stmt, SQL_HANDLE_STMT, ret);
            return;
        }

        // Get number of columns
        SQLSMALLINT columns;
        SQLNumResultCols(stmt, &columns);

        // Fetch and print results
        while (SQL_SUCCESS == SQLFetch(stmt)) {
            for (SQLSMALLINT i = 1; i <= columns; i++) {
                SQLCHAR buffer[512];
                SQLLEN indicator;
                
                ret = SQLGetData(stmt, i, SQL_C_CHAR, buffer, sizeof(buffer), &indicator);
                if (SQL_SUCCESS == ret || SQL_SUCCESS_WITH_INFO == ret) {
                    if (indicator != SQL_NULL_DATA)
                        std::cout << (i > 1 ? "\t" : "") << buffer;
                    else
                        std::cout << (i > 1 ? "\t" : "") << "NULL";
                }
            }
            std::cout << std::endl;
        }
        
        // Reset statement
        SQLCloseCursor(stmt);
    }

    ~DatabaseConnection() {
        if (stmt) SQLFreeHandle(SQL_HANDLE_STMT, stmt);
        if (dbc) {
            SQLDisconnect(dbc);
            SQLFreeHandle(SQL_HANDLE_DBC, dbc);
        }
        if (env) SQLFreeHandle(SQL_HANDLE_ENV, env);
    }
};

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <config_file_path>\n";
        return 1;
    }

    std::string configFile = argv[1];
    std::string connectionString;

    try {
        connectionString = readConnectionString(configFile);
    } catch (const std::exception& e) {
        std::cerr << "Error reading config file: " << e.what() << std::endl;
        return 1;
    }

    std::vector<QueryInfo> queries = {
        {
            "Citizens with land area > 1.00",
            "SELECT c.name "
            "FROM citizens AS c "
            "JOIN land_records AS l ON c.citizen_id = l.citizen_id "
            "WHERE l.land_area > 1.00;"
        },
        {
            "Female students from low-income households",
            "SELECT c1.name "
            "FROM citizens AS c1 "
            "JOIN households AS h ON c1.household_id = h.household_id "
            "WHERE c1.gender = 'Female' "
            "AND c1.is_student = TRUE "
            "AND (SELECT SUM(c2.income) "
            "     FROM citizens AS c2 "
            "     WHERE c2.household_id = h.household_id) "
            "< 100000;"
        },
        {
            "Total rice cultivation area",
            "SELECT SUM(land_area) "
            "FROM land_records "
            "WHERE crop_type ILIKE 'rice';"
        },
        {
            "Young citizens with 10th education",
            "SELECT COUNT(*) "
            "FROM citizens "
            "WHERE dob > '2000-01-01' "
            "AND education ILIKE '10th';"
        },
        {
            "Panchayat employees with land > 1.00",
            "SELECT c.name "
            "FROM citizens AS c "
            "JOIN panchayat_employees AS p ON c.citizen_id = p.citizen_id "
            "JOIN land_records AS l ON p.citizen_id = l.citizen_id "
            "WHERE l.land_area > 1.00;"
        },
        {
            "Household members of Pradhans",
            "SELECT c1.name "
            "FROM citizens AS c1 "
            "JOIN households AS h ON h.household_id = c1.household_id "
            "JOIN citizens AS c2 ON c2.household_id = h.household_id "
            "JOIN panchayat_employees AS p ON p.citizen_id = c2.citizen_id "
            "WHERE p.role ILIKE 'Pradhan';"
        },
        {
            "Street lights in Phulera installed in 2024",
            "SELECT COUNT(*) "
            "FROM assets "
            "WHERE type ILIKE 'Street Light' "
            "AND location ILIKE 'Phulera' "
            "AND EXTRACT(YEAR FROM installation_date) = 2024;"
        },
        {
            "Vaccinations in 2024 for children of 10th pass parents",
            "SELECT COUNT(*) "
            "FROM vaccinations AS v "
            "JOIN citizens as c1 ON v.citizen_id = c1.citizen_id "
            "JOIN citizens AS c2 ON c1.parent_id = c2.citizen_id "
            "WHERE EXTRACT(YEAR FROM v.date_administered) = 2024 "
            "AND c2.education ILIKE '10th';"
        },
        {
            "Male births in 2024",
            "SELECT COUNT(*) from citizens "
            "WHERE gender = 'Male' "
            "AND EXTRACT(YEAR FROM dob) = 2024;"
        },
        {
            "Unique citizens in households with panchayat employees",
            "SELECT COUNT(DISTINCT c1.citizen_id) "
            "FROM citizens AS c1 "
            "JOIN households AS h ON h.household_id = c1.household_id "
            "JOIN citizens AS c2 ON c2.household_id = h.household_id "
            "JOIN panchayat_employees AS p ON p.citizen_id = c2.citizen_id;"
        }
    };

    DatabaseConnection db;
    if (!db.connect(connectionString)) {
        std::cerr << "Failed to connect to database\n";
        return 1;
    }

    for (const auto& query : queries) {
        db.executeQuery(query);
    }

    return 0;
}