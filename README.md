# ДЗ
Если в файле /terraform/.gitignore будет прописано "*.tfvars" - файлы с расширением tfvars не будут попадать в репозиторий.

# ДЗ 2.4. Инструменты Git

- **1.** git show aefea

commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545

Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>

Date:   Thu Jun 18 10:29:58 2020 -0400

    Update CHANGELOG.md

- **2.** git show 85024d3

commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)

- **3.** git show --pretty=raw b8d720

commit b8d720f8340221f2146e4e4870bf2ee0bc48f2d5

tree cec002aab630c8bc701cb85bc94e55e751cd2d8f

**parent 56cd7859e05c36c06b56d013b55a252d0bb7e158**

**parent 9ea88f22fc6269854151c571162c5bcf958bee2b**

...

- **4.** git log --oneline v0.12.23..v0.12.24

33ff1c03b (tag: v0.12.24) v0.12.24

b14b74c49 [Website] vmc provider links

3f235065b Update CHANGELOG.md

6ae64e247 registry: Fix panic when server is unreachable

5c619ca1b website: Remove links to the getting started guide's old location

06275647e Update CHANGELOG.md

d5f9411f5 command: Fix bug when using terraform login on Windows

4b6d06cc5 Update CHANGELOG.md

dd01a3507 Update CHANGELOG.md

225466bc3 Cleanup after v0.12.23 release

- **5.** git log -L:'func providerSource':provider_source.go

commit 5af1e6234ab6da412fb8637393c5a17a1b293663

+func providerSource(configs []*cliconfig.ProviderInstallation, services *disco.Disco) (getproviders.Source, tfdiags.Diagnostics)

- **6.** git log -L:globalPluginDirs:plugins.go

commit 78b12205587fe839f10d946ea3fdc06719decb05

commit 52dbf94834cb970b510f2fba853a5b49ad9b1a46

commit 41ab0aef7a0fe030e84018973a64135b11abcd70

commit 66ebff90cdfaa6938f26f908c7ebad8d547fea17

commit 8364383c359a6b738a436d1b7745ccdce178df47

- **7.** git log -SsynchronizedWriters

commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5

author Martin Atkins <mart@degeneration.co.uk> 1493853941 -0700

# ДЗ Работа в терминале (лекция 1)
