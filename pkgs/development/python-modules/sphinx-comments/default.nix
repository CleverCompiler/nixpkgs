{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinx-comments";
  version = "0.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "00170afff27019fad08e421da1ae49c681831fb2759786f07c826e89ac94cf21";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ sphinx ];

  pythonImportsCheck = [ "sphinx_comments" ];

  meta = with lib; {
    description = "Add comments and annotation to your documentation";
    homepage = "https://github.com/executablebooks/sphinx-comments";
    license = licenses.mit;
    maintainers = [ ];
  };
}
