# GdUnit generated TestSuite
class_name SingletonDataManagerTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source: String = 'res://data/data_manager.gd'

const test_text = """int=5
float=0.5
string="hello"
array=["hello", 5]
dict={"hello": "how","hi": 5}
"""

const test_data: Dictionary[String, Variant] = {
	"int": 5,
	"float": 0.5,
	"string": "hello",
	"array": ["hello", 5],
	"dict": {"hello": "how", "hi": 5},
}

var manager: SingletonDataManager

func before_test() -> void:
	manager = SingletonDataManager.new()

func test_detect_settings_changes() -> void:
	manager._game_settings = "user://test_settings"
	var file: FileAccess = FileAccess.open("user://test_settings", FileAccess.WRITE)
	assert_bool(file.store_string(test_text)).is_true()
	file.close()
	if is_failure(): return
	manager._check_settings_changed()
	assert_str(manager._previous_settings_text).is_equal(test_text)

# also acts as a test for parse_data
func test_parse_settings() -> void:
	manager._parse_settings(test_text)
	assert_bool(manager.settings.has("int"))
	assert_bool(manager.settings.has("float"))
	assert_bool(manager.settings.has("string"))
	assert_bool(manager.settings.has("array"))
	assert_bool(manager.settings.has("dict"))
	if is_failure(): return
	assert_int(manager.settings["int"]).is_equal(5)
	assert_float(manager.settings["float"]).is_equal_approx(0.5, 0.01)
	assert_str(manager.settings["string"]).is_equal("hello")
	assert_array(manager.settings["array"]).is_equal(["hello", 5])
	assert_dict(manager.settings["dict"]).is_equal({"hi": 5, "hello": "how"})

func test_load_data() -> void:
	manager.user_data_file_name = "user://test_data"
	var file: FileAccess = FileAccess.open("user://test_data", FileAccess.WRITE)
	assert_bool(file.store_string(test_text)).is_true()
	file.close()
	manager.load_data()
	assert_dict(manager.data).is_equal(test_data)

func test_save_data() -> void:
	manager.user_data_file_name = "user://test_data"
	manager.data = test_data
	manager.save_data()
	var file: FileAccess = FileAccess.open("user://test_data", FileAccess.READ)
	assert_str(file.get_as_text()).is_equal(test_text)
	file.close()

func test_generate_data() -> void:
	assert_str(SingletonDataManager.generate_data(test_data)).is_equal(test_text)

func after_test() -> void:
	manager.free()
	DirAccess.remove_absolute("user://test_data")
	DirAccess.remove_absolute("user://test_settings")
