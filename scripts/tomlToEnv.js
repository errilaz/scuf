const readFile = require("fs").readFileSync
const { parse } = require("fast-toml")

const path = process.argv[process.argv.length - 1]
const text = readFile(path, "utf8")
const config = parse(text)
const output = writeSection([], config)
console.log(output)

function writeSection(keys, section) {
  let output = ""
  for (const key in section) {
    const value = section[key]
    if (typeof value === "object") {
      output += writeSection([...keys, key], value)
    }
    else {
      output += "export "
        + [...keys, key].join("_").toUpperCase()
        + "=\""
        + value
        + "\"\n"
    }
  }
  return output
}