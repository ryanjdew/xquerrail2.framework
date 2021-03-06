
xquery version "1.0-ml";
module namespace test = "http://github.com/robwhitby/xray/test";
import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/xray/src/assertions.xqy";

import module namespace setup = "http://xquerrail.com/test/setup" at "../../../test/_framework/setup.xqy";
import module namespace app = "http://xquerrail.com/application" at "../../../main/_framework/application.xqy";
import module namespace config = "http://xquerrail.com/config" at "../../../main/_framework/config.xqy";
import module namespace domain = "http://xquerrail.com/domain" at "../../../main/_framework/domain.xqy";

declare option xdmp:mapping "false";

declare variable $TEST-APPLICATION :=
<application xmlns="http://xquerrail.com/config">
  <base>/main</base>
  <config>/test/_framework/domain-test/_config</config>
</application>
;

declare variable $CONFIG := ();

declare %test:teardown function teardown() as empty-sequence()
{
(:  setup:teardown():)
  ()
};

declare %test:before-each function before-test() {
  (app:reset(), app:bootstrap($TEST-APPLICATION))
};

declare %test:case function get-model-model1-test() as item()*
{
  assert:not-empty(domain:get-model("model1"))
};

declare %test:case function get-model-identity-field-name-test() as item()*
{
  let $model1 := domain:get-model("model1")
  return
  assert:equal(domain:get-model-identity-field-name($model1), "uuid")
};

declare %test:case function app-get-setting-test() as item()*
{
  (
    assert:equal(xs:string(app:get-setting("key1")), "value2"),
    assert:equal(fn:count(app:get-setting("key2")/items/item), 2),
    assert:equal(fn:data(app:get-setting("key2")/items/item[1]), 123)
  )
};

declare %test:case function get-model-field-test() as item()* {
  let $model1 := domain:get-model("model1")
  let $field := $model1/domain:element[./@name/fn:string() eq "name"]
  let $_ := xdmp:log(("$model1", $model1, "$field", $field))
  let $field-name := "name"
  let $field-key-id := domain:get-field-id($field)
  let $fiel-key-name := domain:get-field-name-key($field)
  return (
    assert:equal(domain:get-model-field($model1, $field-name), $field),
    assert:equal(domain:get-model-field($model1, $field-key-id), $field),
    assert:equal(domain:get-model-field($model1, $fiel-key-name), $field)
  )
};

