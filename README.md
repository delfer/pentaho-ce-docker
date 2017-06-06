## Pentaho Community Edition Buiseness Platform

#Run
```
docker run --name pentaho-ce -d -p 8080:8080 delfer/pentaho-ce
```

#Persistence
```
docker volume create pentaho
docker run --name pentaho-ce -d -p 8080:8080 -v pentaho:/volume delfer/pentaho-ce
```
**Caution!** Do not try to use shared host directory as volume, it does not work!

#PostgreSQL
**Later...**
