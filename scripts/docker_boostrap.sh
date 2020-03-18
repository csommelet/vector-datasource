set -e
set -x

[ -z "$POSTGRES_PASSWORD" ] && echo "Need to set POSTGRES_PASSWORD" && exit 1;
export PGPASSWORD="$POSTGRES_PASSWORD"

psql -h "${POSTGRES_HOST:-postgres}" \
     -p "${POSTGRES_PORT:-5432}" \
     -U "${POSTGRES_USER:-osm}" \
     -d "${POSTGRES_DB:-osm}" \
     -c "create extension if not exists postgis; create extension if not exists hstore;"

/usr/bin/wget "${OSM_EXTRACT_URL}"
OSM_EXTRACT_FILENAME=${OSM_EXTRACT_URL##*/}
osm2pgsql --slim \
          --cache 1024 \
          --style osm2pgsql.style \
          --hstore-all \
          "${OSM_EXTRACT_FILENAME}" \
          -H "${POSTGRES_HOST:-postgres}" \
          -P "${POSTGRES_PORT:-5432}" \
          -U "${POSTGRES_USER:-osm}" \
          -d "${POSTGRES_DB:-osm}"
rm "${OSM_EXTRACT_FILENAME}"

cd data
/usr/bin/python2 bootstrap.py
/usr/bin/make -f Makefile-import-data
./import-shapefiles.sh | \
    psql -h "${POSTGRES_HOST:-postgres}" \
         -p "${POSTGRES_PORT:-5432}" \
         -U "${POSTGRES_USER:-osm}" \
         -d "${POSTGRES_DB:-osm}"
./perform-sql-updates.sh \
    -h "${POSTGRES_HOST:-postgres}" \
    -p "${POSTGRES_PORT:-5432}" \
    -U "${POSTGRES_USER:-osm}" \
    -d "${POSTGRES_DB:-osm}"
/usr/bin/make -f Makefile-import-data clean
cd ..
