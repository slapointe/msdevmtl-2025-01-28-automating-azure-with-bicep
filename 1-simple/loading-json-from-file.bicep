var config = json(loadTextContent('../_configs/config.json'))
var config2 = loadJsonContent('../_configs/config.json')
var config3 = loadJsonContent('../_configs/config.json', '.tags')

output configOutput object = config
output config2Output object = config2
output config3Output object = config3
