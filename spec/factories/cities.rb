Factory.define :city do |f|
end

Factory.define :shanghai, :class => City do |f|
  f.code "021"
  f.province_id "SH"
  f.name "Shanghai"
  f.eng_name "SHANGHAI"
  f.postcode "20000"
  f.latitude 31.230393
  f.longitude 121.473704
end

Factory.define :beijing, :class => City do |f|
  f.code "010"
  f.province_id "BJ"
  f.name "Beijing"
  f.eng_name "BEIJING"
  f.postcode "10000"
  f.latitude 39.904214
  f.longitude 116.407413
end
