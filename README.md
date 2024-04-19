# labeler-plugin-remote-deploy

This is a plugin to the github.com/clubanderson/labeler project. To use this plugin, simply place the binary for labeler-plugin-remote-deploy in the same path as labeler. Labeler will automatically discover the plugin and incorporate it into execution. 

## To trigger the use of a plugin
Simply add the command line switch in the 'reflect' conditional code-block into your command line for labeler. For labeler-plugin-remote-deploy this would be

```
k <your normal kubectl/kustomize operation and args> --l-remote-contexts=cluster1,cluster2
h <your normal helm operation and args> --l-remote-contexts=cluster1,cluster2
```

This plugin will apply/create (kubectl/kustomize) or install/upgrade (helm) object definitions on any cluster for which you have a matching context in your kubeconfig.

## To build this plugin
```
go build -buildmode=plugin -o bin/labeler-plugin-remote-deploy labeler-plugin-remote-deploy.go
```

## Create your own plugin
To build your own plugin for labeler, use the following template:

```
package main

import (
	"log"
	"strings"

	c "github.com/clubanderson/labeler/pkg/common"
)

func PluginRun() []string {
	return []string{"Plugin<your plugin name>"}
}

func Plugin<your plugin name>(p c.ParamsStruct, reflect bool) []string {
	// function must be exportable (capitalize first letter of function name) to be discovered by labeler
	if reflect {
		return []string{"l-<your command line switch here>,<command line switch type string/bool>,<a description of your command line switches behavior> (usage: <example command line switch usage>)"}
	}
    if p.Params["l-<your command line switch>"] != "" {
        <the behavior you want to happen when this switch is given to labeler>
    }
```

## You have access to resources from labeler
The struct `p` includes

```
type ParamsStruct struct {
	HomeDir       string
	Path          string
	OriginalCmd   string
	Kubeconfig    string
	ClientSet     *kubernetes.Clientset
	RestConfig    *rest.Config
	DynamicClient *dynamic.DynamicClient
	Flags         map[string]bool
	Params        map[string]string
	Resources     map[ResourceStruct][]byte
	PluginArgs    map[string][]string
	PluginPtrs    map[string]reflect.Value
}
```

p.HomeDir       - the home directory of the user running the current command
p.Path          - the path where labeler is executing from (where labeler is installed)
p.OriginalCmd   - contains entire command that was given at the command line - this may come in handy as a way to run another command with the same args
p.Kubeconfig    - the kubeconfig used during run - whatever was given to the command line
p.ClientSet, p.RestConfig, and p.DynamicClient - all ready for you to use in the context given to the original command.
p.Flags and p.Params - the args on the original command line
p.Resources     - a list of all the GVK and the object definitions that helm, kubectl, and kustomize applied/created/installed/upgraded/templated/dry-run'ed
p.PluginArgs    - any command line switches that are reported back by the runtime or compile-time plugins
p.PluginPtrs    - the function pointer reported back by the runtime or compile-time plugins