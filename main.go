package main

// #include <stdlib.h>
import "C"
import (
	"encoding/json"
	"unsafe"

	"github.com/xiatechs/jsonata-go"
)

//export FreeCString
func FreeCString(cstr *C.char) {
	C.free(unsafe.Pointer(cstr))
}

//export EvaluateJSONata
func EvaluateJSONata(jsonData *C.char, expression *C.char) *C.char {
	// Convert C strings to Go strings
	jsonStr := C.GoString(jsonData)
	expressionStr := C.GoString(expression)

	// Compile JSONata expression
	query, err := jsonata.Compile(expressionStr)
	if err != nil {
		result := "Error: " + err.Error()
		return C.CString(result)
	}

	// Parse JSON data
	var data interface{}
	err = json.Unmarshal([]byte(jsonStr), &data)
	if err != nil {
		result := "Error: Invalid JSON data"
		return C.CString(result)
	}

	// Evaluate JSONata expression
	result, err := query.Eval(data)
	if err != nil {
		resultStr := "Error: " + err.Error()
		return C.CString(resultStr)
	}

	// Convert result to JSON string
	resultBytes, err := json.Marshal(result)
	if err != nil {
		resultStr := "Error: " + err.Error()
		return C.CString(resultStr)
	}

	// Convert result to C string and return
	resultStr := string(resultBytes)
	return C.CString(resultStr)
}

func main() {
	// Need a main function to make CGO compile package as C shared library
}
