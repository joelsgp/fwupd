if get_option('tests')
subdir('tests')
endif

client_src = []
systemd_src = []
daemon_dep = [
  libarchive,
  libjcat,
  libxmlb,
  libgcab,
  giounix,
  gmodule,
  gudev,
  gusb,
  libjsonglib,
  polkit,
  sqlite,
  cbor,
]

client_dep = [
  gudev,
  gusb,
  libcurl,
  libjsonglib,
  libxmlb,
  sqlite,
]
if libsystemd.found()
  systemd_src += 'fu-systemd.c'
endif
if polkit.found()
  client_src += 'fu-polkit-agent.c'
endif

fwupd_engine_src = [
  'fu-cabinet-common.c',
  'fu-config.c',
  'fu-debug.c',
  'fu-device-list.c',
  'fu-engine.c',
  'fu-engine-helper.c',
  'fu-engine-request.c',
  'fu-history.c',
  'fu-idle.c',
  'fu-polkit-authority.c',
  'fu-release.c',
  'fu-release-common.c',
  'fu-plugin-list.c',
  'fu-remote-list.c',
  'fu-security-attr-common.c',
] + systemd_src

if gudev.found()
  fwupd_engine_src += 'fu-udev-backend.c'
endif
if gusb.found()
  fwupd_engine_src += 'fu-usb-backend.c'
endif
if bluez.allowed()
  fwupd_engine_src += 'fu-bluez-backend.c'
endif

# include event message file
if host_machine.system() == 'windows'
  windmc = find_program('windmc')
  fwupd_rc = custom_target('fwupd-rc',
    input: 'fwupd-windows.mc',
    output: 'fwupd-windows.rc',
    command: [
      windmc, '@INPUT@', '--rcdir', meson.current_build_dir(),
    ],
  )
  windows = import('windows')
  fwupd_engine_src += windows.compile_resources(fwupd_rc)
endif

fwupdutil = library(
  'fwupdutil',
  sources: [
    'fu-console.c',
    'fu-security-attr-common.c',
    'fu-util-bios-setting.c',
    'fu-util-common.c',
    systemd_src,
  ],
  install: true,
  install_rpath: libdir_pkg,
  install_dir: libdir_pkg,
  include_directories: [
    root_incdir,
    fwupd_incdir,
    fwupdplugin_incdir,
  ],
  dependencies: [
    client_dep,
  ],
  link_with: [
    fwupd,
    fwupdplugin,
  ],
)

if build_daemon
install_data(['org.freedesktop.fwupd.xml'],
  install_dir: join_paths(datadir, 'dbus-1', 'interfaces')
)
fwupdmgr = executable(
  'fwupdmgr',
  sources: [
    'fu-util.c',
    client_src,
  ],
  include_directories: [
    root_incdir,
    fwupd_incdir,
    fwupdplugin_incdir,
  ],
  dependencies: [
    libfwupd_deps,
    client_dep,
  ],
  link_with: [
    fwupd,
    fwupdplugin,
    fwupdutil,
  ],
  install: true,
  install_rpath: libdir_pkg,
  install_dir: bindir
)

# for compatibility
if get_option('compat_cli')
  install_symlink('fwupdagent',
    install_dir: join_paths(get_option('prefix'), get_option('bindir')),
    pointing_to: 'fwupdmgr',
  )
endif
endif

if offline.allowed()
fwupdoffline = executable(
  'fwupdoffline',
  sources: [
    'fu-history.c',
    'fu-offline.c',
    'fu-spawn.c',
    systemd_src
  ],
  include_directories: [
    root_incdir,
    fwupd_incdir,
    fwupdplugin_incdir,
  ],
  dependencies: [
    libfwupd_deps,
    client_dep,
  ],
  link_with: [
    fwupd,
    fwupdplugin,
    fwupdutil,
  ],
  install: true,
  install_rpath: libdir_pkg,
  install_dir: join_paths(libexecdir, 'fwupd')
)
endif

resources_src = gnome.compile_resources(
  'fwupd-resources',
  'fwupd.gresource.xml',
  source_dir: '.',
  c_name: 'fu'
)

# generate a header file that allows us to instantiate the plugins without copy-pasting or
# duplicating the meson build logic in the engine
plugin_names = []
foreach lib : plugin_builtins
  plugin_names += lib.full_path()
endforeach
plugins_hdr = custom_target('fwupd-generate-plugins-header',
  output : 'fu-plugin-builtin.h',
  command : [
    join_paths(meson.project_source_root(), 'contrib', 'generate-plugins-header.py'),
    '@OUTPUT@',
    meson.project_source_root(),
    ','.join(plugin_names),
  ],
)

# build all the plugins and engine into one installed library
fwupdengine = library(
  'fwupdengine',
  resources_src,
  plugins_hdr,
  sources: fwupd_engine_src,
  install: true,
  install_rpath: libdir_pkg,
  install_dir: libdir_pkg,
  include_directories: plugin_incdirs,
  dependencies: [
    daemon_dep,
  ],
  link_whole: [
    plugin_builtins,
  ],
  link_with: [
    fwupd,
    fwupdplugin,
  ],
)

fwupdtool = executable(
  'fwupdtool',
  resources_src,
  plugins_hdr,
  export_dynamic: true,
  sources: [
    'fu-tool.c',
  ],
  include_directories: [
    root_incdir,
    fwupd_incdir,
    fwupdplugin_incdir,
  ],
  dependencies: [
    libfwupd_deps,
    libgcab,
    libarchive,
    client_dep,
    valgrind,
  ],
  link_with: [
    fwupdengine,
    fwupdutil,
    plugin_libs,
  ],
  install: true,
  install_rpath: libdir_pkg,
  install_dir: bindir
)

if get_option('man')
  if build_daemon
    custom_target('fwupdmgr.1',
      input: 'fwupdmgr.md',
      output: 'fwupdmgr.1',
      command: [
        generate_man, '@INPUT@', '-o', '@OUTPUT@',
        '--replace', '@PACKAGE_VERSION@', fwupd_version,
      ],
      install: true,
      install_dir: join_paths(mandir, 'man1'),
    )
  endif
  if build_daemon and get_option('compat_cli')
    custom_target('fwupdagent.1',
      input: 'fwupdagent.md',
      output: 'fwupdagent.1',
      command: [
        generate_man, '@INPUT@', '-o', '@OUTPUT@',
        '--replace', '@PACKAGE_VERSION@', fwupd_version,
      ],
      install: true,
      install_dir: join_paths(mandir, 'man1'),
    )
  endif
  if build_standalone
    custom_target('fwupdtool.1',
      input: 'fwupdtool.md',
      output: 'fwupdtool.1',
      command: [
        generate_man, '@INPUT@', '-o', '@OUTPUT@',
        '--replace', '@PACKAGE_VERSION@', fwupd_version,
      ],
      install: true,
      install_dir: join_paths(mandir, 'man1'),
    )
  endif
endif

if build_daemon

# the StartServiceCtrlDispatcherA design is so different use a different source file
if host_machine.system() == 'windows'
  daemon_loader_src = 'fu-main-windows.c'
else
  daemon_loader_src = 'fu-main.c'
endif

executable(
  'fwupd',
  resources_src,
  plugins_hdr,
  sources: [
    daemon_loader_src,
    'fu-daemon.c',
  ],
  include_directories: [
    root_incdir,
    fwupd_incdir,
    fwupdplugin_incdir,
  ],
  dependencies: [
    valgrind,
    libsystemd,
    daemon_dep,
  ],
  link_with: [
    fwupdengine,
    plugin_libs,
  ],
  c_args: [
    '-DFU_OFFLINE_DESTDIR=""',
  ],
  install: true,
  install_rpath: libdir_pkg,
  install_dir: daemon_dir
)

endif

if get_option('tests')
  env = environment()
  env.set('G_TEST_SRCDIR', meson.current_source_dir())
  env.set('G_TEST_BUILDDIR', meson.current_build_dir())
  env.set('FWUPD_LOCALSTATEDIR', '/tmp/fwupd-self-test/var')
  e = executable(
    'fu-self-test',
    resources_src,
    colorhug_test_firmware,
    hwid_test_firmware,
    multiple_rels_test_firmware,
    noreqs_test_firmware,
    plugins_hdr,
    sources: [
      'fu-spawn.c',
      'fu-self-test.c',
    ],
    include_directories: [
      root_incdir,
      fwupd_incdir,
      fwupdplugin_incdir,
    ],
    dependencies: [
      daemon_dep,
    ],
    link_with: [
      fwupdengine,
      fwupdutil,
      plugin_libs,
    ],
    c_args: [
      '-DSRCDIR="' + meson.current_source_dir() + '"',
    ],
  )
  test('fu-self-test', e, is_parallel: false, timeout: 180, env: env)
endif
