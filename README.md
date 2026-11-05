# Plant 3D to Revit Converter

Use this Plant 3D to Revit converter to turn a Plant 3D PCF piping model into Revit Fabrication Parts. This converter uses Plyry AI to propose mappings to your Revit fabrication services and reports anything it cannot map; you can review and correct those items, then apply the completed mapping in Revit. The Revit model uses the PCF coordinates, so review the resulting part placement and fitting orientations in your project.

## Supported Revit builds

| Revit | .NET target |
| --- | --- |
| 2024 | .NET Framework 4.8 |
| 2025 | .NET 8 for Windows |
| 2026 | .NET 8 for Windows |
| 2027 | .NET 10 for Windows |

Build each add-in against the Revit API installed on the machine that will run it. The shared core uses .NET Standard 2.0 for the mapping-package data model. Revit 2027 uses .NET 10; install the matching .NET SDK and Revit API before building that target.

## Requirements

- A Revit project with the target Fabrication Configuration and services loaded.
- Visual Studio 2022 or the .NET SDK that matches the Revit release, plus its API assemblies.

## Build and install

From this repository folder, build for a Revit version installed at the default Autodesk path:

```powershell
.\build.ps1 -RevitYear 2025
```

Install the add-in in the current Windows user profile:

```powershell
.\install.ps1 -RevitYear 2025
```

For a non-standard Revit installation, provide its folder or the API DLL paths:

```powershell
.\install.ps1 -RevitYear 2024 -RevitInstallDir 'D:\Apps\Autodesk\Revit 2024'
```

The project also builds in Visual Studio when `RevitYear` is set to `2024`, `2025`, `2026`, or `2027`, using the matching .NET target shown above. It does not bundle Autodesk API assemblies. Restart Revit after installation; a **Plyry** ribbon tab will contain **Export Fabrication Catalog** and **Apply PCF Mapping**.

## Conversion flow

1. Open the target Revit project and load its fabrication configuration and services.
2. In Revit, run **Plyry → Export Fabrication Catalog**. The JSON includes the Revit version and service, palette, button, and condition identifiers needed to resolve a mapping in that project. Hangers and buttons without usable conditions are excluded because this add-in does not place them.
3. In Revit, run **Plyry → Plant 3D Converter**. Sign in or create a Plyry account in the add-in, then select the PCF and exported catalog. The app links to your account through the Plyry API and stores its refresh token encrypted for your Windows user.
4. Plyry AI parses PCF component blocks and coordinates, proposes matches using SKEY/item-code/button metadata, and returns component groups, candidate matches, and a missing-match report.
5. Review or correct service buttons in the in-app report, search all placeable buttons from the exported Revit catalog when a suggestion is missing, and run mapping again. Revisions on the same job do not charge again.
6. When all groups have a target, download the `.plyrymap.json` package in the add-in. In the Revit project that exported the catalog, run **Plyry → Apply PCF Mapping**.

The in-app Account tab supports direct sign-in and account creation, displays the current wallet balance and conversion price, and lets you add funds without opening a Plyry account page. Card details are sent to the configured payment processor for tokenization; Plyry receives only the processor payment-method ID. If the card requires a bank verification step, the app opens that provider action in the system browser, then returns to the add-in through a one-time localhost callback and verifies the payment through the API.

The add-in creates Fabrication Parts from the selected service buttons, sizes straight pipe parts from the PCF bore, positions component records from PCF coordinates, and attempts to join coincident end connectors. Revit reports any parts it could not place. Check the resulting fabrication validation, fitting orientation, and connections before issuing or fabricating a model; configurations vary and some fittings require manual correction.

## Mapping package

The downloadable JSON uses `schema_version: 1`. It contains the source file/pipeline, the target Revit profile/version, every parsed PCF component and its coordinates in meters, and the chosen `service_id`, `palette_index`, and `button_index`. The add-in checks the Revit major version, active fabrication profile, and button identity before placing parts. These identifiers are specific to the exported configuration; export a new catalog after changing Revit versions or fabrication configurations.

## License

The code and documentation in this repository are licensed under the Apache License 2.0; see [LICENSE](LICENSE). Revit API assemblies are not included and remain subject to Autodesk's terms.
