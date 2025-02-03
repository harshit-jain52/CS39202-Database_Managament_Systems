run:
	if [ ! -f postgresql-42.7.2.jar ]; then wget https://jdbc.postgresql.org/download/postgresql-42.7.2.jar; fi
	javac -cp postgresql-42.7.2.jar DatabaseQueries.java
	java -cp .:postgresql-42.7.2.jar DatabaseQueries db.properties

clean:
	rm -f *.class