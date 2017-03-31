%global _hardened_build 1

Name:		sha1collisiondetector
Version:	1.0.1
Release:	1%{?dist}
Summary:	A SHA-1 collision detector CLI tool

License:	MIT
URL:		https://github.com/LeSuisse/sha1collisiondetector
Source0:	https://github.com/LeSuisse/sha1collisiondetector/releases/download/%{version}/%{version}.tar.gz

%description
%{summary}.

%prep
%setup -c %{name}

%build
make %{?_smp_mflags}

%install
mkdir -p %{buildroot}%{_bindir}/
cp -p sha1collisiondetector %{buildroot}%{_bindir}/

%check
make test

%files
%defattr(-,root,root,-)
%doc README.md
%{_bindir}/sha1collisiondetector

%changelog
* Fri Mar 31 2017 Thomas Gerbet <thomas@gerbet.me> - 1.0.1-1
- Update to version 1.0.1

* Wed Mar 22 2017 Thomas Gerbet <thomas@gerbet.me> - 1.0.0-1
- Initial package release
