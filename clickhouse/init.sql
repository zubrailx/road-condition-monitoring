drop table if exists points;

create table points (
  `time` DateTime,
  `latitude` Float64,
  `longitude` Float64,
  `prediction` Float32
) 
ENGINE = MergeTree()
ORDER BY (`time`, `latitude`, `longitude`)
PARTITION BY toYYYYMM(`time`)


