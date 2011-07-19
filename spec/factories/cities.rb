Factory.define :city do |f|
end

Factory.define :shanghai, :class => City do |f|
  f.code "021"
  f.province_id "SH"
  f.name "ShangHai"
  f.eng_name "SHANGHAI"
  f.postcode "20000"
  f.latitude 31.230393
  f.longitude 121.473704
end
