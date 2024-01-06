json.query "submit_ioc"
json.threat_type "payload_delivery"
json.ioc_type "domain"
json.malware "foobar"
json.confidence_level 100
json.anonymous 0
json.iocs artifacts.map(&:data)
