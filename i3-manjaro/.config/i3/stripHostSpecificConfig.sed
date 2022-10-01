#!/bin/sed -f
/# <hostSpecificConfig>/,/# <\/hostSpecificConfig>/{/# <config hostname="ganderson">/,/# <\/config>/!d}

