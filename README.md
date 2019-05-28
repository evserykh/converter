Web application providing conversion documents from one format to another using on LibreOffice.

# Running

```
docker run --rm -it -p 3000:3000 -p 8080:8080 evserykh/converter
```

# Endpoints

## Sinatra Web Application

This is a wrapper supporting encoding input text documents to UTF-8 before conversion.

```
curl -X POST -F file=@/path/to/file.xls http://localhost:3000/convert -F from='application/vnd.ms-excel' -F to='text/csv' -o output.csv
```

## JODConverter Web Application

Visit [http://localhost:8080/converter](http://localhost:8080/converter)

# Development

```
git clone https://github.com/evserykh/converter.git && cd converter
mkdir .bundle
docker-compose build
docker-compose run --rm app bundle
docker-compose up
```
