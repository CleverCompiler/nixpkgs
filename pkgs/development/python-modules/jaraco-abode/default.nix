{ lib
, buildPythonPackage
, bx-py-utils
, colorlog
, fetchFromGitHub
, importlib-resources
, jaraco-classes
, jaraco-collections
, jaraco-itertools
, jaraco-context
, jaraco-net
, keyring
, lomond
, more-itertools
, platformdirs
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
, requests-toolbelt
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "jaraco-abode";
  version = "5.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.abode";
    rev = "refs/tags/v${version}";
    hash = "sha256-TUxljF1k/fvQoNcHx6jMRJrYgzxjXefvMl+mBD0DL8o=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    requests
    lomond
    colorlog
    keyring
    requests-toolbelt
    jaraco-collections
    jaraco-context
    jaraco-classes
    jaraco-net
    more-itertools
    importlib-resources
    bx-py-utils
    platformdirs
    jaraco-itertools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "jaraco.abode"
  ];

  preCheck = ''
    export HOME=$TEMP
  '';

  disabledTests = [
    "_cookie_string"
    "test_cookies"
    "test_empty_cookies"
    "test_invalid_cookies"
    # Issue with the regex
    "test_camera_capture_no_control_URLs"
  ];

  meta = with lib; {
    changelog = "https://github.com/jaraco/jaraco.abode/blob/${version}/CHANGES.rst";
    homepage = "https://github.com/jaraco/jaraco.abode";
    description = "Library interfacing to the Abode home security system";
    mainProgram = "abode";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee dotlambda ];
  };
}
