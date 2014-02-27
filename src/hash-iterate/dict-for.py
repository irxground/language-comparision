values = { 'foo': 1, 'bar': 2, 'baz': 3 }
for k in values:
  print k + ': ' + `values[k]`
print '----'
for k, v in values.items():
  print k + ': ' + `v`
