#!/bin/bash

run_python() {
    echo "Running psycopg2 (Python)..."
    cd psycopg2/
    ./run.sh
    cd ..
}

run_cpp() {
    echo "Running ODBC (C++)..."
    cd ODBC/
    make run
    make clean
    cd ..
}

run_java() {
    echo "Running JDBC (Java)..."
    cd JDBC/
    make run
    make clean
    cd ..
}

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 {python|cpp|java|all}"
    exit 1
fi

case "$1" in
    python)
        run_python
        ;;
    cpp)
        run_cpp
        ;;
    java)
        run_java
        ;;
    all)
        run_python
        run_cpp
        run_java
        ;;
    *)
        echo "Invalid option: $1"
        echo "Usage: $0 {python|cpp|java|all}"
        exit 1
        ;;
esac
