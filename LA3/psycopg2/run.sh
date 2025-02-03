if [ ! -d "venv" ]; then
    python3 -m venv venv
    source ./venv/bin/activate
    pip install --upgrade pip
    pip install psycopg2-binary python-dotenv
    deactivate
fi

source ./venv/bin/activate
python3 queries.py